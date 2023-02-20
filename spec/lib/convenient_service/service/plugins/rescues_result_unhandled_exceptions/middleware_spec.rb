# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_class, :result, middlewares: described_class) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      context "when service result does NOT raise exceptions" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              success
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
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller.take(10)
            end
          end
        end

        let(:exception) do
          service_class.result(*args, **kwargs, &block)
        rescue => error
          error
        end

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.map { |line| "# #{line}" }.join("\n")}
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
            .with_arguments(exception: exception, args: args, kwargs: kwargs, block: block)
        end

        it "returns failure with formatted exception" do
          expect(method_value).to be_failure.with_data(exception: formatted_exception)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
