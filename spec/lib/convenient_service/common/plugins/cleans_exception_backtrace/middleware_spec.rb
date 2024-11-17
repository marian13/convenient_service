# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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
          intended_for any_method, scope: any_scope, entity: any_entity
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
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_instance, :initialize, observe_middleware: middleware) }

      let(:service_instance) { service_class.allocate }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      context "when NO exception is raised" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
              end
            end
          end
        end

        specify { expect { method_value }.to call_chain_next.on(method).with_arguments(*args, **kwargs, &block) }
      end

      context "when exception is raised" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "exception from `#initialize`"
              end
            end
          end
        end

        specify do
          expect { ignoring_exception(ArgumentError) { method_value } }
            .to call_chain_next.on(method).with_arguments(*args, **kwargs, &block)
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "cleans that exception backtrace" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.message).to eq("exception from `#initialize`")
            expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when exception is reraised" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "exception from `#initialize`"
              rescue
                raise ArgumentError, "reraised exception from `#initialize`"
              end
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "cleans that reraised exception backtrace" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.message).to eq("reraised exception from `#initialize`")
            expect(exception.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations

        # rubocop:disable RSpec/MultipleExpectations
        it "cleans that reraised exception cause backtrace" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.cause.message).to eq("exception from `#initialize`")
            expect(exception.cause.backtrace.none? { |line| line.start_with?(ConvenientService.lib_root.to_s) }).to eq(true)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when exception is monkey-patched" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "monkey-patched exception from `#initialize`"
              rescue => exception
                exception.define_singleton_method(:foo) { :foo }

                raise exception
              end
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "does NOT recreate that monkey-patched exception (returns same exception instance)" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.foo).to eq(:foo)
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when exception has NO backtrace" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "exception from `#initialize`"
              rescue => exception
                exception.define_singleton_method(:backtrace) { nil }

                raise exception
              end
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "ignores that exception backtrace" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.backtrace).to be_nil
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when exception cause has NO backtrace" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                exception = ArgumentError.new("exception from `#initialize`")

                exception.define_singleton_method(:backtrace) { nil }

                raise exception
              rescue
                raise ArgumentError, "reraised exception from `#initialize`"
              end
            end
          end
        end

        # rubocop:disable RSpec/MultipleExpectations
        it "ignores that exception cause backtrace" do
          expect { method_value }.to raise_error(ArgumentError) do |exception|
            expect(exception.cause.backtrace).to be_nil
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when `backtrace_cleaner` is NOT passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                observe middleware
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "exception from `#initialize`"
              end
            end
          end
        end

        specify do
          expect { ignoring_exception(ArgumentError) { method_value } }
            .to delegate_to(ConvenientService.backtrace_cleaner, :clean)
        end
      end

      context "when `backtrace_cleaner` is passed" do
        let(:method) { wrap_method(service_instance, :initialize, observe_middleware: middleware.with(backtrace_cleaner: backtrace_cleaner)) }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware, backtrace_cleaner) do |middleware, backtrace_cleaner|
              include ConvenientService::Standard::Config

              middlewares :initialize do
                replace middleware, middleware.with(backtrace_cleaner: backtrace_cleaner)

                observe middleware.with(backtrace_cleaner: backtrace_cleaner)
              end

              def initialize(*args, **kwargs, &block)
                raise ArgumentError, "exception from `#initialize`"
              end
            end
          end
        end

        let(:backtrace_cleaner) { ConvenientService::Support::BacktraceCleaner.new }

        specify do
          expect { ignoring_exception(ArgumentError) { method_value } }
            .to delegate_to(backtrace_cleaner, :clean)
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
