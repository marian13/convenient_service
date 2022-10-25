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

      context "when concerns are NOT configured" do
        specify { expect { service_class.concerns }.not_to cache_its_value }

        it "returns concerns" do
          expect(service_class.concerns).to eq(concerns)
        end
      end

      context "when concerns are configured at least once" do
        before { service_class.concerns {} }

        specify { expect { service_class.concerns }.to cache_its_value }

        it "returns concerns" do
          expect(service_class.concerns).to eq(concerns)
        end
      end
    end

    context "when `configuration_block` is passed" do
      ##
      # NOTE: Simplest concern is just a module.
      #
      let(:concern) { Module.new }
      let(:concerns) { ConvenientService::Core::Entities::Concerns.new(entity: service_class).configure(&configuration_block) }
      let(:configuration_block) { proc { |stack| stack.use concern } }

      before do
        ##
        # NOTE: Configures `concerns` in order to cache them.
        #
        service_class.concerns {}
      end

      specify do
        expect { service_class.concerns(&configuration_block) }
          .to delegate_to(service_class.concerns, :assert_not_included!)
      end

      specify do
        expect { service_class.concerns(&configuration_block) }
          .to delegate_to(service_class.concerns, :configure)
          .with_arguments(&configuration_block)
      end

      specify { expect { service_class.concerns(&configuration_block) }.to cache_its_value }

      it "returns concerns" do
        expect(service_class.concerns(&configuration_block)).to eq(concerns)
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

      context "when middlewares are NOT configured" do
        context "when `scope` is NOT passed" do
          specify { expect { service_class.middlewares(method) }.not_to cache_its_value }

          it "returns instance middlewares for `method`" do
            expect(service_class.middlewares(method)).to eq(instance_method_middlewares)
          end
        end

        context "when `scope` is passed" do
          context "when `scope` is `:instance`" do
            specify { expect { service_class.middlewares(method, scope: :instance) }.not_to cache_its_value }

            it "returns instance middlewares for `method`" do
              expect(service_class.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
            end
          end

          context "when `scope` is `:class`" do
            specify { expect { service_class.middlewares(method, scope: :class) }.not_to cache_its_value }

            it "returns class middlewares for `method`" do
              expect(service_class.middlewares(method, scope: :class)).to eq(class_method_middlewares)
            end
          end
        end
      end

      context "when middlewares are configured at least once" do
        context "when `scope` is NOT passed" do
          before { service_class.middlewares(method) {} }

          specify { expect { service_class.middlewares(method) }.to cache_its_value }

          it "returns instance middlewares for `method`" do
            expect(service_class.middlewares(method)).to eq(instance_method_middlewares)
          end
        end

        context "when `scope` is passed" do
          context "when `scope` is `:instance`" do
            before { service_class.middlewares(method, scope: :instance) {} }

            specify { expect { service_class.middlewares(method, scope: :instance) }.to cache_its_value }

            it "returns instance middlewares for `method`" do
              expect(service_class.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
            end
          end

          context "when `scope` is `:class`" do
            before { service_class.middlewares(method, scope: :class) {} }

            specify { expect { service_class.middlewares(method, scope: :class) }.to cache_its_value }

            it "returns class middlewares for `method`" do
              expect(service_class.middlewares(method, scope: :class)).to eq(class_method_middlewares)
            end
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
        let(:configuration_block) { instance_method_configuration_block }
        let(:method_middlewares) { instance_method_middlewares }

        before do
          ##
          # NOTE: Configures `middlewares` in order to cache them.
          #
          service_class.middlewares(method) {}
        end

        specify do
          expect { service_class.middlewares(method, &configuration_block) }
            .to delegate_to(service_class.middlewares(method), :configure)
            .with_arguments(&configuration_block)
        end

        specify do
          expect { service_class.middlewares(method, &configuration_block) }
            .to delegate_to(service_class.middlewares(method), :define!)
        end

        specify do
          expect { service_class.middlewares(method, &configuration_block) }
            .to cache_its_value
        end

        it "returns instance middlewares for `method`" do
          expect(service_class.middlewares(method, &configuration_block)).to eq(method_middlewares)
        end
      end

      context "when `scope` is passed" do
        context "when `scope` is `:instance`" do
          let(:scope) { :instance }
          let(:configuration_block) { instance_method_configuration_block }
          let(:method_middlewares) { instance_method_middlewares }

          before do
            ##
            # NOTE: Configures `middlewares` in order to cache them.
            #
            service_class.middlewares(method, scope: scope) {}
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to delegate_to(service_class.middlewares(method, scope: scope), :configure)
              .with_arguments(&configuration_block)
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to delegate_to(service_class.middlewares(method, scope: scope), :define!)
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to cache_its_value
          end

          it "returns instance middlewares for `method`" do
            expect(service_class.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
          end
        end

        context "when `scope` is `:class`" do
          let(:scope) { :class }
          let(:configuration_block) { class_method_configuration_block }
          let(:method_middlewares) { class_method_middlewares }

          before do
            ##
            # NOTE: Configures `middlewares` in order to cache them.
            #
            service_class.middlewares(method, scope: scope) {}
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to delegate_to(service_class.middlewares(method, scope: scope), :configure)
              .with_arguments(&configuration_block)
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to delegate_to(service_class.middlewares(method, scope: scope), :define!)
          end

          specify do
            expect { service_class.middlewares(method, scope: scope, &configuration_block) }
              .to cache_its_value
          end

          it "returns class middlewares for `method`" do
            expect(service_class.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
          end
        end
      end
    end
  end

  describe "#commit_config" do
    let(:service_class) do
      Class.new do
        include ConvenientService::Core
      end
    end

    before do
      ##
      # NOTE: Configures `concerns` in order to cache them.
      #
      service_class.concerns {}
    end

    specify do
      expect { service_class.commit_config! }.to delegate_to(service_class.concerns, :include!)
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
