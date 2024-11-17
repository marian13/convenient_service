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
          intended_for [:result, :negated_result], scope: :instance, entity: :service
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

        let(:exception) { service_class.result(*args, **kwargs, &block).unsafe_data[:unhandled_exception] }

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
                include ConvenientService::Standard::Config.with(:fault_tolerance)

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
                  include ConvenientService::Standard::Config.with(:fault_tolerance)

                  middlewares :result, scope: :class do
                    observe middleware
                  end

                  def result
                    ##
                    # NOTE: `/end_user/` is added to avoid backtrace filtering.
                    #
                    raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
                  end
                end
              end
            end

            let(:method) { wrap_method(service_class, :result, observe_middleware: middleware) }

            it "defaults to `:error`" do
              expect(method_value).to be_error.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
            end
          end

          context "when status is passed" do
            let(:method) { wrap_method(service_class, :result, observe_middleware: middleware.with(status: status, max_backtrace_size: max_backtrace_size)) }

            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware, status, max_backtrace_size) do |middleware, status, max_backtrace_size|
                  include ConvenientService::Standard::Config.with(:fault_tolerance)

                  middlewares :result, scope: :class do
                    delete middleware

                    use_and_observe middleware.with(status: status, max_backtrace_size: max_backtrace_size)
                  end

                  middlewares :result do
                    delete middleware
                  end

                  def result
                    ##
                    # NOTE: `/end_user/` is added to avoid backtrace filtering.
                    #
                    raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
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
                expect(method_value).to be_failure.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
              end

              it "returns `failure` from exception" do
                expect(method_value.from_unhandled_exception?).to eq(true)
              end

              it "returns `failure` with exception" do
                expect(method_value.unhandled_exception).to eq(exception)
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
                expect(method_value).to be_error.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
              end

              it "returns `error` from exception" do
                expect(method_value.from_unhandled_exception?).to eq(true)
              end

              it "returns `error` with exception" do
                expect(method_value.unhandled_exception).to eq(exception)
              end
            end
          end

          context "when `max_backtrace_size` is NOT passed" do
            let(:service_class) do
              Class.new.tap do |klass|
                klass.class_exec(middleware) do |middleware|
                  include ConvenientService::Standard::Config.with(:fault_tolerance)

                  middlewares :result, scope: :class do
                    observe middleware
                  end

                  middlewares :result do
                    delete middleware
                  end

                  def result
                    ##
                    # NOTE: `/end_user/` is added to avoid backtrace filtering.
                    #
                    raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
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

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        context "when middleware is used for instance method" do
          include ConvenientService::RSpec::Helpers::WrapMethod

          include ConvenientService::RSpec::Matchers::CallChainNext
          include ConvenientService::RSpec::Matchers::DelegateTo
          include ConvenientService::RSpec::Matchers::Results

          subject(:method_value) { method.call }

          let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware.with(max_backtrace_size: max_backtrace_size)) }

          let(:service_instance) { service_class.new }

          let(:max_backtrace_size) { 5 }

          let(:exception) { service_class.new.__send__(method_name).unsafe_data[:unhandled_exception] }

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
                klass.class_exec(method_name, scope, middleware, max_backtrace_size) do |method_name, scope, middleware, max_backtrace_size|
                  include ConvenientService::Standard::Config.with(:fault_tolerance)

                  middlewares method_name, scope: scope do
                    replace middleware, middleware.with(max_backtrace_size: max_backtrace_size)

                    observe middleware.with(max_backtrace_size: max_backtrace_size)
                  end

                  define_method(method_name) do
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
                  klass.class_exec(method_name, scope, middleware) do |method_name, scope, middleware|
                    include ConvenientService::Standard::Config.with(:fault_tolerance)

                    middlewares method_name, scope: scope do
                      observe middleware
                    end

                    define_method(method_name) do
                      ##
                      # NOTE: `/end_user/` is added to avoid backtrace filtering.
                      #
                      raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
                    end
                  end
                end
              end

              let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }

              it "defaults to `:error`" do
                expect(method_value).to be_error.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
              end
            end

            context "when status is passed" do
              let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware.with(status: status, max_backtrace_size: max_backtrace_size)) }

              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(method_name, scope, middleware, status, max_backtrace_size) do |method_name, scope, middleware, status, max_backtrace_size|
                    include ConvenientService::Standard::Config.with(:fault_tolerance)

                    middlewares method_name, scope: scope do
                      replace middleware, middleware.with(status: status, max_backtrace_size: max_backtrace_size)

                      observe middleware.with(status: status, max_backtrace_size: max_backtrace_size)
                    end

                    define_method(method_name) do
                      ##
                      # NOTE: `/end_user/` is added to avoid backtrace filtering.
                      #
                      raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
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
                  expect(method_value).to be_failure.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
                end

                it "returns `failure` from exception" do
                  expect(method_value.from_unhandled_exception?).to eq(true)
                end

                it "returns `failure` with exception" do
                  expect(method_value.unhandled_exception).to eq(exception)
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
                  expect(method_value).to be_error.with_data(unhandled_exception: exception).and_message(formatted_exception).and_code(:unhandled_exception)
                end

                it "returns `error` from exception" do
                  expect(method_value.from_unhandled_exception?).to eq(true)
                end

                it "returns `error` with exception" do
                  expect(method_value.unhandled_exception).to eq(exception)
                end
              end
            end

            context "when `max_backtrace_size` is NOT passed" do
              let(:service_class) do
                Class.new.tap do |klass|
                  klass.class_exec(method_name, scope, middleware) do |method_name, scope, middleware|
                    include ConvenientService::Standard::Config.with(:fault_tolerance)

                    middlewares method_name, scope: scope do
                      observe middleware
                    end

                    define_method(method_name) do
                      ##
                      # NOTE: `/end_user/` is added to avoid backtrace filtering.
                      #
                      raise StandardError, "exception message", caller.take(5).map { |line| line.prepend("/end_user/") }
                    end
                  end
                end
              end

              let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }
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

  context "when method is instance `:result`" do
    include_examples "verify middleware behavior" do
      let(:scope) { :instance }
      let(:method_name) { :result }
    end
  end

  context "when method is instance `:negated_result`" do
    include_examples "verify middleware behavior" do
      let(:scope) { :instance }
      let(:method_name) { :negated_result }
    end
  end

  ##
  # TODO: Fallbacks always return `success`. Probably a dedicated rescue should be created?
  #
  # context "when method is instance `:fallback_failure_result`" do
  #   include_examples "verify middleware behavior" do
  #     let(:scope) { :instance }
  #     let(:method_name) { :fallback_failure_result }
  #   end
  # end
  #
  # context "when method is instance `:fallback_error_result`" do
  #   include_examples "verify middleware behavior" do
  #     let(:scope) { :instance }
  #     let(:method_name) { :fallback_error_result }
  #   end
  # end
  #
  # context "when method is instance `:fallback_result`" do
  #   include_examples "verify middleware behavior" do
  #     let(:scope) { :instance }
  #     let(:method_name) { :fallback_result }
  #   end
  # end
  ##
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
