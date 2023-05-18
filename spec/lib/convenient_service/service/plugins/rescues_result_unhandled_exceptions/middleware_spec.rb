# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :result, scope: :class
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_class, :result, observe_middleware: middleware.with(max_backtrace_size: max_backtrace_size)) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      let(:max_backtrace_size) { 5 }

      context "when service result does NOT raise exceptions" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, max_backtrace_size) do |middleware, max_backtrace_size|
              include ConvenientService::Configs::Minimal

              middlewares :result, scope: :class do
                use_and_observe middleware.with(max_backtrace_size: max_backtrace_size)
              end

              def result
                success
              end
            end
          end
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(*args, **kwargs, &block)
            .and_return_its_value
        end
      end

      context "when service result raises exceptions" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, max_backtrace_size) do |middleware, max_backtrace_size|
              include ConvenientService::Configs::Minimal

              middlewares :result, scope: :class do
                use_and_observe middleware.with(max_backtrace_size: max_backtrace_size)
              end

              def result
                raise StandardError, "exception message", caller.take(5)
              end
            end
          end
        end

        let(:exception) { service_class.result(*args, **kwargs, &block).unsafe_data[:exception] }

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(max_backtrace_size).map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(*args, **kwargs, &block)
        end

        specify do
          expect { method_value }
            .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
            .with_arguments(exception: exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size)
        end

        it "returns failure with formatted exception" do
          expect(method_value).to be_failure.with_data(exception: exception).and_message(formatted_exception)
        end

        context "when `max_backtrace_size` is NOT passed" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Configs::Minimal

                middlewares :result, scope: :class do
                  use_and_observe middleware
                end

                def result
                  raise StandardError, "exception message", caller.take(5)
                end
              end
            end
          end

          let(:method) { wrap_method(service_class, :result, observe_middleware: middleware) }
          let(:max_backtrace_size) { ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE }

          it "defaults to `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE`" do
            expect { method_value }
              .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
              .with_arguments(exception: exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
