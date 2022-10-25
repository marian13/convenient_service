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
      let(:result) { service_class.concerns }

      let(:concerns) { ConvenientService::Core::Entities::Concerns.new(entity: service_class) }

      specify { expect { result }.to cache_its_value }

      it "returns concerns" do
        expect(result).to eq(concerns)
      end
    end

    context "when `configuration_block` is passed" do
      let(:result) { service_class.concerns(&configuration_block) }

      ##
      # NOTE: Simplest concern is just a module.
      #
      let(:concern) { Module.new }

      let(:concerns) do
        ConvenientService::Core::Entities::Concerns
          .new(entity: service_class)
          .configure(&configuration_block)
      end

      let(:configuration_block) { proc { |stack| stack.use concern } }

      specify { expect { result }.to delegate_to(service_class.concerns, :assert_not_included!) }

      specify do
        expect { result }
          .to delegate_to(service_class.concerns, :configure)
          .with_arguments(&configuration_block)
      end

      specify { expect { result }.to cache_its_value }

      it "returns concerns" do
        expect(result).to eq(concerns)
      end
    end
  end

  describe "#middlewares" do
    let(:method) { :result }

    let(:service_class) do
      Class.new do
        include ConvenientService::Core
      end
    end

    context "when `configuration_block` is NOT passed" do
      let(:result) { service_class.middlewares(method, **kwargs) }

      let(:instance_method_middlewares) { ConvenientService::Core::Entities::MethodMiddlewares.new(scope: :instance, method: method, klass: service_class) }
      let(:class_method_middlewares) { ConvenientService::Core::Entities::MethodMiddlewares.new(scope: :class, method: method, klass: service_class) }

      context "when `scope` is NOT passed" do
        let(:result) { service_class.middlewares(method) }

        specify { expect { result }.to cache_its_value }

        it "returns instance middlewares for `method`" do
          expect(result).to eq(instance_method_middlewares)
        end
      end

      context "when `scope` is passed" do
        let(:result) { service_class.middlewares(method, scope: :instance) }

        context "when `scope` is `:instance`" do
          specify { expect { result }.to cache_its_value }

          it "returns instance middlewares for `method`" do
            expect(result).to eq(instance_method_middlewares)
          end
        end

        context "when `scope` is `:class`" do
          let(:result) { service_class.middlewares(method, scope: :class) }

          specify { expect { result }.to cache_its_value }

          it "returns class middlewares for `method`" do
            expect(result).to eq(class_method_middlewares)
          end
        end
      end
    end

    context "when `configuration_block` is passed" do
      let(:instance_method_middleware) do
        Class.new(ConvenientService::Core::MethodChainMiddleware) do
          def next(...)
            chain.next(...)
          end
        end
      end

      let(:class_method_middleware) do
        Class.new(ConvenientService::Core::MethodChainMiddleware) do
          def next(...)
            chain.next(...)
          end
        end
      end

      let(:instance_method_configuration_block) { proc { |stack| stack.use instance_method_middleware } }
      let(:class_method_configuration_block) { proc { |stack| stack.use class_method_middleware } }

      let(:instance_method_middlewares) do
        ConvenientService::Core::Entities::MethodMiddlewares
          .new(scope: :instance, method: method, klass: service_class)
          .configure(&instance_method_configuration_block)
      end

      let(:class_method_middlewares) do
        ConvenientService::Core::Entities::MethodMiddlewares
          .new(scope: :class, method: method, klass: service_class)
          .configure(&class_method_configuration_block)
      end

      context "when `scope` is NOT passed" do
        let(:result) { service_class.middlewares(method, &instance_method_configuration_block) }

        specify do
          expect { result }
            .to delegate_to(service_class.middlewares(method), :configure)
            .with_arguments(&instance_method_configuration_block)
        end

        specify { expect { result }.to delegate_to(service_class.middlewares(method), :define!) }

        specify { expect { result }.to cache_its_value }

        it "returns instance middlewares for `method`" do
          expect(result).to eq(instance_method_middlewares)
        end
      end

      context "when `scope` is passed" do
        let(:result) { service_class.middlewares(method, scope: :instance, &instance_method_configuration_block) }

        context "when `scope` is `:instance`" do
          let(:scope) { :instance }

          specify do
            expect { result }
              .to delegate_to(service_class.middlewares(method, scope: scope), :configure)
              .with_arguments(&instance_method_configuration_block)
          end

          specify { expect { result }.to delegate_to(service_class.middlewares(method, scope: scope), :define!) }

          specify { expect { result }.to cache_its_value }

          it "returns instance middlewares for `method`" do
            expect(result).to eq(instance_method_middlewares)
          end
        end

        context "when `scope` is `:class`" do
          let(:result) { service_class.middlewares(method, scope: :class, &class_method_configuration_block) }

          let(:scope) { :class }

          specify do
            expect { result }
              .to delegate_to(service_class.middlewares(method, scope: scope), :configure)
              .with_arguments(&class_method_configuration_block)
          end

          specify { expect { result }.to delegate_to(service_class.middlewares(method, scope: scope), :define!) }

          specify { expect { result }.to cache_its_value }

          it "returns class middlewares for `method`" do
            expect(result).to eq(class_method_middlewares)
          end
        end
      end
    end
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
