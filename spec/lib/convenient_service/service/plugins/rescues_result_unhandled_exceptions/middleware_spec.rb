# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for [:regular_result, :steps_result], scope: :instance, entity: :service
          intended_for :result, scope: :class, entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      context "when middleware is used for `:result` class method" do
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

        let(:exception) { service_class.result(*args, **kwargs, &block).unsafe_data[:exception] }

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(max_backtrace_size).map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        context "when service result does NOT raise exceptions" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware, max_backtrace_size) do |middleware, max_backtrace_size|
                include ConvenientService::Standard::Config
                include ConvenientService::FaultTolerance::Config

                middlewares :result, scope: :class do
                  delete middleware

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
          context "when `status` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :result, scope: :class do
                    observe middleware
                  end

                  def result
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            let(:method) { wrap_method(service_class, :result, observe_middleware: middleware) }

            it "defaults to `:error`" do
              expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
            end
          end

          context "when status is passed" do
            let(:method) { wrap_method(service_class, :result, observe_middleware: middleware.with(status: status, max_backtrace_size: max_backtrace_size)) }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware, status, max_backtrace_size) do |middleware, status, max_backtrace_size|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :result, scope: :class do
                    delete middleware

                    use_and_observe middleware.with(status: status, max_backtrace_size: max_backtrace_size)
                  end

                  middlewares :regular_result do
                    delete middleware
                  end

                  def result
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            context "when `status` is `:failure`" do
              let(:status) { :failure }

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

              it "returns `failure` with formatted exception" do
                expect(method_value).to be_failure.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `failure` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `failure` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end

            context "when `status` is `:error`" do
              let(:status) { :error }

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

              it "returns `error` with formatted exception" do
                expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `error` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `error` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end
          end

          context "when `max_backtrace_size` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :result, scope: :class do
                    observe middleware
                  end

                  middlewares :regular_result do
                    delete middleware
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

      context "when middleware is used for `:regular_result` instance method" do
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::DelegateTo
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, :regular_result, observe_middleware: middleware.with(max_backtrace_size: max_backtrace_size)) }

        let(:service_instance) { service_class.new }

        let(:max_backtrace_size) { 5 }

        let(:exception) { service_class.new.result.unsafe_data[:exception] }

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(max_backtrace_size).map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        context "when service result does NOT raise exceptions" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware, max_backtrace_size) do |middleware, max_backtrace_size|
                include ConvenientService::Standard::Config
                include ConvenientService::FaultTolerance::Config

                middlewares :regular_result do
                  delete middleware

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
              .without_arguments
              .and_return_its_value
          end
        end

        context "when service result raises exceptions" do
          context "when `status` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :regular_result do
                    observe middleware
                  end

                  def result
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            let(:method) { wrap_method(service_instance, :regular_result, observe_middleware: middleware) }

            it "defaults to `:error`" do
              expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
            end
          end

          context "when status is passed" do
            let(:method) { wrap_method(service_instance, :regular_result, observe_middleware: middleware.with(status: status, max_backtrace_size: max_backtrace_size)) }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware, status, max_backtrace_size) do |middleware, status, max_backtrace_size|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :regular_result do
                    delete middleware

                    use_and_observe middleware.with(status: status, max_backtrace_size: max_backtrace_size)
                  end

                  def result
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            context "when `status` is `:failure`" do
              let(:status) { :failure }

              specify do
                expect { method_value }
                  .to call_chain_next.on(method)
                  .without_arguments
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                  .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
              end

              it "returns `failure` with formatted exception" do
                expect(method_value).to be_failure.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `failure` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `failure` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end

            context "when `status` is `:error`" do
              let(:status) { :error }

              specify do
                expect { method_value }
                  .to call_chain_next.on(method)
                  .without_arguments
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                  .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
              end

              it "returns `error` with formatted exception" do
                expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `error` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `error` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end
          end

          context "when `max_backtrace_size` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :regular_result do
                    observe middleware
                  end

                  def result
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            let(:method) { wrap_method(service_instance, :regular_result, observe_middleware: middleware) }
            let(:max_backtrace_size) { ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE }

            it "defaults to `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE`" do
              expect { method_value }
                .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
            end
          end
        end
      end

      context "when middleware is used for `:steps_result` instance method" do
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext
        include ConvenientService::RSpec::Matchers::DelegateTo
        include ConvenientService::RSpec::Matchers::Results

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, :steps_result, observe_middleware: middleware.with(max_backtrace_size: max_backtrace_size)) }

        let(:service_instance) { service_class.new }

        let(:max_backtrace_size) { 5 }

        let(:exception) { service_class.new.result.unsafe_data[:exception] }

        let(:formatted_exception) do
          <<~MESSAGE.chomp
            #{exception.class}:
              #{exception.message}
            #{exception.backtrace.take(max_backtrace_size).map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        context "when service result does NOT raise exceptions" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware, max_backtrace_size) do |middleware, max_backtrace_size|
                include ConvenientService::Standard::Config
                include ConvenientService::FaultTolerance::Config

                middlewares :steps_result do
                  delete middleware

                  use_and_observe middleware.with(max_backtrace_size: max_backtrace_size)
                end

                step :foo

                def foo
                  success
                end
              end
            end
          end

          specify do
            expect { method_value }
              .to call_chain_next.on(method)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when service result raises exceptions" do
          context "when `status` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :steps_result do
                    observe middleware
                  end

                  step :foo

                  def foo
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            let(:method) { wrap_method(service_instance, :steps_result, observe_middleware: middleware) }

            it "defaults to `:error`" do
              expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
            end
          end

          context "when status is passed" do
            let(:method) { wrap_method(service_instance, :steps_result, observe_middleware: middleware.with(status: status, max_backtrace_size: max_backtrace_size)) }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware, status, max_backtrace_size) do |middleware, status, max_backtrace_size|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :steps_result do
                    delete middleware

                    use_and_observe middleware.with(status: status, max_backtrace_size: max_backtrace_size)
                  end

                  step :foo

                  def foo
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            context "when `status` is `:failure`" do
              let(:status) { :failure }

              specify do
                expect { method_value }
                  .to call_chain_next.on(method)
                  .without_arguments
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                  .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
              end

              it "returns `failure` with formatted exception" do
                expect(method_value).to be_failure.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `failure` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `failure` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end

            context "when `status` is `:error`" do
              let(:status) { :error }

              specify do
                expect { method_value }
                  .to call_chain_next.on(method)
                  .without_arguments
              end

              specify do
                expect { method_value }
                  .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                  .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
              end

              it "returns `error` with formatted exception" do
                expect(method_value).to be_error.with_data(exception: exception).and_message(formatted_exception)
              end

              it "returns `error` from exception" do
                expect(method_value.from_exception?).to eq(true)
              end

              it "returns `error` with exception" do
                expect(method_value.exception).to eq(exception)
              end
            end
          end

          context "when `max_backtrace_size` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config
                  include ConvenientService::FaultTolerance::Config

                  middlewares :steps_result do
                    observe middleware
                  end

                  step :foo

                  def foo
                    raise StandardError, "exception message", caller.take(5)
                  end
                end
              end
            end

            let(:method) { wrap_method(service_instance, :steps_result, observe_middleware: middleware) }
            let(:max_backtrace_size) { ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE }

            it "defaults to `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants::DEFAULT_MAX_BACKTRACE_SIZE`" do
              expect { method_value }
                .to delegate_to(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException, :call)
                .with_arguments(exception: exception, args: [], kwargs: {}, block: nil, max_backtrace_size: max_backtrace_size)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
