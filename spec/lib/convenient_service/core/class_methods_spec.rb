# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  describe "#concerns" do
    let(:service_class) do
      Class.new do
        include ConvenientService::Core
      end
    end

    context "when `configuration_block` is NOT passed" do
      let(:concerns) { ConvenientService::Core::Entities::Concerns.new(entity: service_class) }

      it "returns concerns" do
        expect(service_class.concerns).to eq(concerns)
      end

      specify { expect { service_class.concerns }.to cache_its_value }
    end

    context "when `configuration_block` is passed" do
      let(:concerns) do
        ConvenientService::Core::Entities::Concerns.new(entity: service_class)
          .tap { |concerns| concerns.configure(&configuration_block) }
      end

      let(:configuration_block) do
        proc do
          ##
          # NOTE: Simplest concern is just a module.
          #
          concern = Module.new do
            class << self
              ##
              # NOTE: `name` returns `nil` when module is anonymous.
              # `name` and `==` are overridden to make sure that module was defined in this particular test suite.
              # https://ruby-doc.org/core-2.7.0/Module.html#method-i-name
              #
              # NOTE: For `expect(service_class.concerns(&configuration_block)).to eq(concerns)`.
              #
              def name
                "Anonymous module from test"
              end

              def ==(other)
                name == other.name
              end
            end
          end

          use concern
        end
      end

      specify {
        expect { service_class.concerns(&configuration_block) }
          .to delegate_to(service_class.concerns, :assert_not_included!)
      }

      specify {
        expect { service_class.concerns(&configuration_block) }
          .to delegate_to(service_class.concerns, :configure)
          .with_arguments(&configuration_block)
      }

      it "returns concerns" do
        expect(service_class.concerns(&configuration_block)).to eq(concerns)
      end
    end
  end

  describe "#middlewares" do
    let(:method) { :result }

    let(:instance_method_middleware) do
      Class.new(ConvenientService::Core::MethodChainMiddleware) do
        def next(*args, **kwargs, &block)
          chain.next(*args, **kwargs, &block)
        end
      end
    end

    let(:class_method_middleware) do
      Class.new(ConvenientService::Core::MethodChainMiddleware) do
        def next(*args, **kwargs, &block)
          chain.next(*args, **kwargs, &block)
        end
      end
    end

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(method, instance_method_middleware, class_method_middleware) do |method, instance_method_middleware, class_method_middleware|
          include ConvenientService::Core

          middlewares(method, scope: :instance).configure(instance_method_middleware) do |instance_method_middleware|
            use instance_method_middleware
          end

          middlewares(method, scope: :class).configure(class_method_middleware) do |class_method_middleware|
            use class_method_middleware
          end
        end
      end
    end

    let(:configuration_block) do
      proc do
      end
    end

    context "when `configuration_block` is NOT passed" do
      let(:middlewares) { service_class.middlewares(method, **kwargs) }

      let(:instance_method_middlewares) do
        ConvenientService::Core::Entities::MethodMiddlewares
          .new(scope: :instance, method: method, container: service_class)
          .configure(instance_method_middleware) { |middleware| use middleware }
      end

      let(:class_method_middlewares) do
        ConvenientService::Core::Entities::MethodMiddlewares
          .new(scope: :class, method: method, container: service_class)
          .configure(class_method_middleware) { |middleware| use middleware }
      end

      context "when `scope` is NOT passed" do
        let(:middlewares) { service_class.middlewares(method) }

        it "returns instance middlewares for `method`" do
          expect(middlewares).to eq(instance_method_middlewares)
        end
      end

      context "when `scope` is passed" do
        let(:middlewares) { service_class.middlewares(method, scope: :instance) }

        context "when `scope` is `:instance`" do
          it "returns instance middlewares for `method`" do
            expect(middlewares).to eq(instance_method_middlewares)
          end
        end

        context "when `scope` is `:class`" do
          let(:middlewares) { service_class.middlewares(method, scope: :class) }

          it "returns class middlewares for `method`" do
            expect(middlewares).to eq(class_method_middlewares)
          end
        end
      end
    end

    ##
    # TODO:
    #
    # context "when `configuration_block` is passed" do
    # end
  end

  describe "#method_missing" do
    let(:service_class) do
      Class.new do
        include ConvenientService::Core

        concerns do
          ##
          # NOTE: Defines `foo` that is later extended by service class by `concerns.include!`.
          #
          concern =
            Module.new do
              include ConvenientService::Support::Concern

              class_methods do
                def foo(*args, **kwargs, &block)
                  [:foo, args, kwargs, block&.source_location]
                end
              end
            end

          use concern
        end
      end
    end

    let(:args) { [:foo] }
    let(:kwargs) { {foo: :bar} }
    let(:block) { proc { :foo } }

    it "includes concerns" do
      ##
      # NOTE: Intentionally calling missed method. But later it is added by `concerns.include!`.
      #
      expect { service_class.foo }.to delegate_to(service_class.concerns, :include!)
    end

    ##
    # TODO: `it "logs debug message"`.
    #

    it "calls super" do
      ##
      # NOTE: If `[:foo, args, kwargs, block&.source_location]` is returned, then `super` was called. See concern above.
      #
      expect(service_class.foo(*args, **kwargs, &block)).to eq([:foo, args, kwargs, block&.source_location])
    end

    context "when concerns are included more than once (since they do not contain required class method)" do
      it "raises `NoMethodError`" do
        ##
        # NOTE: Intentionally calling missed method that won't be included even by concern.
        #
        expect { service_class.bar }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#respond_to_missing?" do
    let(:method_name) { :foo }
    let(:result) { service_class.respond_to_missing?(method_name, include_private) }

    context "when `include_private` is `false`" do
      let(:include_private) { false }

      context "when service class does NOT have public class method" do
        context "when concerns do NOT have public class method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(result).to eq(false)
          end

          context "when service class has private class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                class << self
                  private

                  def foo
                  end
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end
          end

          context "when concerns have private class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    include ConvenientService::Support::Concern

                    class_methods do
                      private

                      def foo
                      end
                    end
                  end

                  use concern
                end
              end
            end

            it "returns `false`" do
              expect(result).to eq(false)
            end
          end
        end

        context "when concerns have public class method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              concerns do
                concern = Module.new do
                  include ConvenientService::Support::Concern

                  class_methods do
                    def foo
                    end
                  end
                end

                use concern
              end
            end
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when service class has public instance method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            class << self
              def foo
              end
            end
          end
        end

        it "returns `true`" do
          expect(result).to eq(true)
        end
      end
    end

    context "when `include_private` is `true`" do
      let(:include_private) { true }

      context "when service class does NOT have public class method" do
        context "when concerns do NOT have public class method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core
            end
          end

          it "returns `false`" do
            expect(result).to eq(false)
          end

          context "when service class has private class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                class << self
                  private

                  def foo
                  end
                end
              end
            end

            it "returns `true`" do
              expect(result).to eq(true)
            end
          end

          context "when concerns have private class method" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                concerns do
                  concern = Module.new do
                    include ConvenientService::Support::Concern

                    class_methods do
                      private

                      def foo
                      end
                    end
                  end

                  use concern
                end
              end
            end

            it "returns `true`" do
              expect(result).to eq(true)
            end
          end
        end

        context "when concerns have public class method" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              concerns do
                concern = Module.new do
                  include ConvenientService::Support::Concern

                  class_methods do
                    def foo
                    end
                  end
                end

                use concern
              end
            end
          end

          it "returns `true`" do
            expect(result).to eq(true)
          end
        end
      end

      context "when service class has public instance method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Core

            class << self
              def foo
              end
            end
          end
        end

        it "returns `true`" do
          expect(result).to eq(true)
        end
      end
    end

    context "when `include_private` is NOT passed" do
      let(:result) { service_class.respond_to_missing?(method_name) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Core

          class << self
            private

            def foo
            end
          end
        end
      end

      it "defaults to `false`" do
        ##
        # NOTE: private methods are ignored when `include_private` is `false`.
        #
        expect(result).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
