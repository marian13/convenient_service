# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:method_middlewares) { described_class.new(scope: scope, method: method, klass: klass) }

  let(:scope) { :instance }
  let(:method) { :result }
  let(:klass) { service_class }
  let(:container) { described_class::Entities::Container.new(klass: klass) }

  let(:prefix) { described_class::Entities::Caller::Constants::INSTANCE_PREFIX }
  let(:caller) { described_class::Entities::Caller.new(prefix: prefix) }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core

      def result
        :original_method_value
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_instance }

  let(:env) { {args: [], kwargs: {}, block: nil, entity: entity} }
  let(:original_method) { proc { |env| service_instance.result(*env[:args], **env[:kwargs], &env[:block]) } }

  let(:middleware) do
    Class.new(ConvenientService::MethodChainMiddleware) do
      def next(...)
        :middleware_value
      end
    end
  end

  let(:other_middleware) do
    Class.new(ConvenientService::MethodChainMiddleware) do
      def next(...)
        :original_method_value
      end
    end
  end

  example_group "instance methods" do
    describe "#no_super_method_exception_message_for" do
      it "returns message" do
        expect(method_middlewares.no_super_method_exception_message_for(entity)).to eq("super: no superclass method `#{method}' for #{entity}")
      end
    end

    describe "#defined?" do
      context "when methods middlewares callers do NOT contain own instance method" do
        it "returns `false`" do
          expect(method_middlewares.defined?).to eq(false)
        end
      end

      context "when methods middlewares callers contain own instance method" do
        before do
          method_middlewares.define!
        end

        it "returns `true`" do
          expect(method_middlewares.defined?).to eq(true)
        end
      end
    end

    describe "#super_method_defined?" do
      context "when methods middlewares are NOT defined" do
        context "when super method is NOT defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(method_middlewares.super_method_defined?).to eq(false)
          end
        end

        context "when super method is defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              def result
                :original_method_value
              end
            end
          end

          it "returns `true`" do
            expect(method_middlewares.super_method_defined?).to eq(false)
          end
        end
      end

      context "when methods middlewares are defined" do
        before do
          method_middlewares.define!
        end

        context "when super method is NOT defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(method_middlewares.super_method_defined?).to eq(false)
          end
        end

        context "when super method is defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              def result
                :original_method_value
              end
            end
          end

          it "returns `true`" do
            expect(method_middlewares.super_method_defined?).to eq(true)
          end
        end
      end
    end

    describe "#defined_without_super_method?" do
      context "when method middlewares are NOT defined" do
        it "returns `false`" do
          expect(method_middlewares.defined_without_super_method?).to eq(false)
        end
      end

      context "when method middlewares are defined" do
        before do
          method_middlewares.define!
        end

        context "when super method is NOT defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `true`" do
            expect(method_middlewares.defined_without_super_method?).to eq(true)
          end
        end

        context "when super method is defined" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              def result
                :original_method_value
              end
            end
          end

          it "returns `false`" do
            expect(method_middlewares.defined_without_super_method?).to eq(false)
          end
        end
      end
    end

    describe "#configure" do
      context "when `configuration_block` does NOT have one argument" do
        ##
        # NOTE: Calls `use` that is defined in stack.
        #
        let(:configuration_block) do
          proc do
            middleware = Class.new(ConvenientService::MethodChainMiddleware) do
              def next(...)
                :middleware_value
              end
            end

            use middleware
          end
        end

        it "executes `configuration_block` in stack context" do
          expect { method_middlewares.configure(&configuration_block) }.not_to raise_error
        end

        it "configures stack" do
          method_middlewares.configure(&configuration_block)

          ##
          # NOTE: If stack is configured correctly then returns value for middleware. See how it is defined.
          #
          expect(method_middlewares.call(env, original_method)).to eq(:middleware_value)
        end

        it "returns method middlewares" do
          expect(method_middlewares.configure(&configuration_block)).to eq(method_middlewares)
        end
      end

      context "when `configuration_block` has one argument" do
        let(:middleware) do
          Class.new(ConvenientService::MethodChainMiddleware) do
            def next(...)
              :middleware_value
            end
          end
        end

        ##
        # NOTE: Calls `middleware` that is defined in the enclosing context.
        #
        let(:configuration_block) { proc { |stack| stack.use middleware } }

        it "executes `configuration_block` in enclosing context" do
          expect { method_middlewares.configure(&configuration_block) }.not_to raise_error
        end

        it "configures stack" do
          method_middlewares.configure(&configuration_block)

          ##
          # NOTE: If stack is configured correctly then returns value for middleware. See how it is defined.
          #
          expect(method_middlewares.call(env, original_method)).to eq(:middleware_value)
        end

        it "returns method middlewares" do
          expect(method_middlewares.configure(&configuration_block)).to eq(method_middlewares)
        end
      end
    end

    describe "#define!" do
      before do
        ##
        # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
        # NOTE: Used for `and_return_its_value`.
        # https://github.com/marian13/convenient_service/blob/c5b3adc4a0edc2d631dd1f44f914c28eeafefe1d/lib/convenient_service/rspec/matchers/custom/delegate_to.rb#L105
        #
        method_middlewares.define!
      end

      specify do
        expect { method_middlewares.define! }
          .to delegate_to(described_class::Entities::Caller::Commands::DefineMethodCallers, :call)
          .with_arguments(scope: scope, method: method, container: container, caller: caller)
          .and_return_its_value
      end
    end

    describe "#call" do
      let(:env) { {args: [], kwargs: {}, block: nil, entity: entity, method: :result} }

      let(:original_method) { proc { |env| service_instance.result(*env[:args], **env[:kwargs], &env[:block]) } }

      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          def result
            [:original_method_value]
          end
        end
      end

      let(:proxy_middleware) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          def next(...)
            [:proxy_middleware_value]
          end
        end
      end

      let(:decorator_middleware) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          def next(...)
            [:decorator_middleware_value, *chain.next(...)]
          end
        end
      end

      context "when stack is NOT empty" do
        context "when stack has one middleware" do
          context "when that middleware is proxy" do
            before do
              service_class.middlewares(:result) do |stack|
                stack.use proxy_middleware
              end
            end

            it "calls that proxy middleware" do
              expect(method_middlewares.call(env, original_method)).to eq([:proxy_middleware_value])
            end

            it "copies stack to be thread-safe" do
              expect { method_middlewares.call(env, original_method) }.not_to change { method_middlewares.to_a.size }
            end
          end

          context "when that middleware is decorator" do
            before do
              service_class.middlewares(:result) do |stack|
                stack.use decorator_middleware
              end
            end

            it "calls that decorator middleware + original method" do
              expect(method_middlewares.call(env, original_method)).to eq([:decorator_middleware_value, :original_method_value])
            end

            it "copies stack to be thread-safe" do
              expect { method_middlewares.call(env, original_method) }.not_to change { method_middlewares.to_a.size }
            end
          end
        end

        context "when stack has multiple middlewares" do
          before do
            service_class.middlewares(:result) do |stack|
              stack.use decorator_middleware
            end
          end

          context "when last middleware from those middlewares is proxy" do
            before do
              service_class.middlewares(:result) do |stack|
                stack.use proxy_middleware
              end
            end

            it "calls those multiple middlewares + that last proxy middleware" do
              expect(method_middlewares.call(env, original_method)).to eq([:decorator_middleware_value, :proxy_middleware_value])
            end

            it "copies stack to be thread-safe" do
              expect { method_middlewares.call(env, original_method) }.not_to change { method_middlewares.to_a.size }
            end
          end

          context "when last middleware from those middlewares is decorator" do
            before do
              service_class.middlewares(:result) do |stack|
                stack.use decorator_middleware
              end
            end

            it "calls those multiple middlewares + that last decorator middleware + original method" do
              expect(method_middlewares.call(env, original_method)).to eq([:decorator_middleware_value, :decorator_middleware_value, :original_method_value])
            end

            it "copies stack to be thread-safe" do
              expect { method_middlewares.call(env, original_method) }.not_to change { method_middlewares.to_a.size }
            end
          end
        end
      end

      context "when stack is empty" do
        it "calls original method" do
          expect(method_middlewares.call(env, original_method)).to eq([:original_method_value])
        end

        it "copies stack to be thread-safe" do
          expect { method_middlewares.call(env, original_method) }.not_to change { method_middlewares.to_a.size }
        end
      end
    end

    describe "#resolve_super_method" do
      context "when `service_class` does NOT have `method` (own or inherited)" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            middlewares(:result) {}
          end
        end

        specify do
          expect { method_middlewares.resolve_super_method(entity) }
            .to delegate_to(service_class, :commit_config!)
            .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD)
        end

        it "returns `nil`" do
          expect(method_middlewares.resolve_super_method(entity)).to eq(nil)
        end
      end

      context "when `service_class` has `method` (own or inherited)" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            middlewares(:result) {}

            def result
            end
          end
        end

        let(:super_method) { ConvenientService::Utils::Module.get_own_instance_method(service_class, method, private: true).bind(service_instance) }

        specify do
          expect { method_middlewares.resolve_super_method(entity) }
            .to delegate_to(service_class, :commit_config!)
            .with_arguments(trigger: ConvenientService::Core::Constants::Triggers::RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD)
        end

        it "returns super method" do
          expect(method_middlewares.resolve_super_method(entity)).to eq(super_method)
        end
      end
    end

    describe "#to_a" do
      context "when stack is NOT empty" do
        it "returns middleware classes" do
          method_middlewares.configure do |stack|
            stack.use middleware
            stack.use other_middleware
          end

          expect(method_middlewares.to_a).to eq([middleware, other_middleware])
        end
      end

      context "when stack is empty" do
        it "returns empty array" do
          expect(method_middlewares.to_a).to eq([])
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:method_middlewares) { described_class.new(scope: scope, method: method, klass: klass) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(method_middlewares == other).to be_nil
          end
        end

        context "when `other` has different `scope`" do
          let(:other) { described_class.new(scope: :class, method: method, klass: klass) }

          it "returns `false`" do
            expect(method_middlewares == other).to eq(false)
          end
        end

        context "when `other` has different `method`" do
          let(:other) { described_class.new(scope: scope, method: :step, klass: klass) }

          it "returns `false`" do
            expect(method_middlewares == other).to eq(false)
          end
        end

        context "when `other` has different `klass`" do
          let(:other) { described_class.new(scope: scope, method: method, klass: Class.new) }

          it "returns `false`" do
            expect(method_middlewares == other).to eq(false)
          end
        end

        context "when `other` has different `stack`" do
          let(:other) { described_class.new(scope: scope, method: method, klass: klass).configure { |stack| stack.use middleware } }

          it "returns `false`" do
            expect(method_middlewares == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(scope: scope, method: method, klass: klass) }

          it "returns `true`" do
            expect(method_middlewares == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
