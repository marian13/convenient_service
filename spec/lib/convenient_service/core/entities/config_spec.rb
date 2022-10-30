# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:config) { described_class.new(klass: service_class) }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:committed_config_error_message) do
    <<~TEXT
      Config for `#{config.klass}` is already committed. Only uncommitted configs can be modified.

      Did you accidentally call `concerns(&configuration_block)` or `middlewares(method, scope: scope, &configuration_block)` after using any plugin, after calling `commit_config!`?
    TEXT
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { config }

    it { is_expected.to have_attr_reader(:klass) }
  end

  example_group "instance methods" do
    describe "#concerns" do
      context "when `configuration_block` is NOT passed" do
        let(:concerns) { ConvenientService::Core::Entities::Config::Entities::Concerns.new(klass: service_class) }

        context "when concerns are NOT configured" do
          specify { expect { config.concerns }.not_to cache_its_value }

          it "returns concerns" do
            expect(config.concerns).to eq(concerns)
          end
        end

        context "when concerns are configured at least once" do
          before { config.concerns {} }

          specify { expect { config.concerns }.to cache_its_value }

          it "returns concerns" do
            expect(config.concerns).to eq(concerns)
          end
        end
      end

      context "when `configuration_block` is passed" do
        ##
        # NOTE: Simplest concern is just a module.
        #
        let(:concern) { Module.new }
        let(:concerns) { ConvenientService::Core::Entities::Config::Entities::Concerns.new(klass: service_class).configure(&configuration_block) }
        let(:configuration_block) { proc { |stack| stack.use concern } }

        context "when config is NOT commited" do
          before do
            ##
            # NOTE: Configures `concerns` in order to cache them.
            #
            config.concerns {}
          end

          specify do
            expect { config.concerns(&configuration_block) }
              .to delegate_to(config, :assert_not_committed!)
          end

          specify do
            expect { config.concerns(&configuration_block) }
              .to delegate_to(config.concerns, :configure)
              .with_arguments(&configuration_block)
          end

          specify { expect { config.concerns(&configuration_block) }.to cache_its_value }

          it "returns concerns" do
            expect(config.concerns(&configuration_block)).to eq(concerns)
          end
        end

        context "when config is commited" do
          before do
            config.commit!
          end

          it "raises `ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted`" do
            expect { config.concerns(&configuration_block) }
              .to raise_error(ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted)
              .with_message(committed_config_error_message)
          end
        end
      end
    end

    describe "#middlewares" do
      let(:method) { :result }

      context "when `configuration_block` is NOT passed" do
        let(:result) { config.middlewares(method, **kwargs) }

        let(:instance_method_middlewares) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares.new(scope: :instance, method: method, klass: service_class) }
        let(:class_method_middlewares) { ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares.new(scope: :class, method: method, klass: service_class) }

        context "when middlewares are NOT configured" do
          context "when `scope` is NOT passed" do
            specify { expect { config.middlewares(method) }.not_to cache_its_value }

            it "returns instance middlewares for `method`" do
              expect(config.middlewares(method)).to eq(instance_method_middlewares)
            end
          end

          context "when `scope` is passed" do
            context "when `scope` is `:instance`" do
              specify { expect { config.middlewares(method, scope: :instance) }.not_to cache_its_value }

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
              end
            end

            context "when `scope` is `:class`" do
              specify { expect { config.middlewares(method, scope: :class) }.not_to cache_its_value }

              it "returns class middlewares for `method`" do
                expect(config.middlewares(method, scope: :class)).to eq(class_method_middlewares)
              end
            end
          end
        end

        context "when middlewares are configured at least once" do
          context "when `scope` is NOT passed" do
            before { config.middlewares(method) {} }

            specify { expect { config.middlewares(method) }.to cache_its_value }

            it "returns instance middlewares for `method`" do
              expect(config.middlewares(method)).to eq(instance_method_middlewares)
            end
          end

          context "when `scope` is passed" do
            context "when `scope` is `:instance`" do
              before { config.middlewares(method, scope: :instance) {} }

              specify { expect { config.middlewares(method, scope: :instance) }.to cache_its_value }

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
              end
            end

            context "when `scope` is `:class`" do
              before { config.middlewares(method, scope: :class) {} }

              specify { expect { config.middlewares(method, scope: :class) }.to cache_its_value }

              it "returns class middlewares for `method`" do
                expect(config.middlewares(method, scope: :class)).to eq(class_method_middlewares)
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
          ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares
            .new(scope: :instance, method: method, klass: service_class)
            .configure(&instance_method_configuration_block)
        end

        let(:class_method_middlewares) do
          ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares
            .new(scope: :class, method: method, klass: service_class)
            .configure(&class_method_configuration_block)
        end

        context "when `scope` is NOT passed" do
          let(:configuration_block) { instance_method_configuration_block }
          let(:method_middlewares) { instance_method_middlewares }

          context "when config is NOT committed" do
            before do
              ##
              # NOTE: Configures `middlewares` in order to cache them.
              #
              config.middlewares(method) {}
            end

            specify do
              expect { config.middlewares(method, &configuration_block) }
                .to delegate_to(config, :assert_not_committed!)
            end

            specify do
              expect { config.middlewares(method, &configuration_block) }
                .to delegate_to(config.middlewares(method), :configure)
                .with_arguments(&configuration_block)
            end

            specify do
              expect { config.middlewares(method, &configuration_block) }
                .to delegate_to(config.middlewares(method), :define!)
            end

            specify do
              expect { config.middlewares(method, &configuration_block) }
                .to cache_its_value
            end

            it "returns instance middlewares for `method`" do
              expect(config.middlewares(method, &configuration_block)).to eq(method_middlewares)
            end
          end

          context "when config is commited" do
            before do
              config.commit!
            end

            it "raises `ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted`" do
              expect { config.middlewares(method, &configuration_block) }
                .to raise_error(ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted)
                .with_message(committed_config_error_message)
            end
          end
        end

        context "when `scope` is passed" do
          context "when `scope` is `:instance`" do
            let(:scope) { :instance }
            let(:configuration_block) { instance_method_configuration_block }
            let(:method_middlewares) { instance_method_middlewares }

            context "when config is NOT committed" do
              before do
                ##
                # NOTE: Configures `middlewares` in order to cache them.
                #
                config.middlewares(method, scope: scope) {}
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config, :assert_not_committed!)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config.middlewares(method, scope: scope), :configure)
                  .with_arguments(&configuration_block)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config.middlewares(method, scope: scope), :define!)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to cache_its_value
              end

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
              end
            end

            context "when config is commited" do
              before do
                config.commit!
              end

              it "raises `ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted`" do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to raise_error(ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted)
                  .with_message(committed_config_error_message)
              end
            end
          end

          context "when `scope` is `:class`" do
            let(:scope) { :class }
            let(:configuration_block) { class_method_configuration_block }
            let(:method_middlewares) { class_method_middlewares }

            context "when config is NOT committed" do
              before do
                ##
                # NOTE: Configures `middlewares` in order to cache them.
                #
                config.middlewares(method, scope: scope) {}
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config, :assert_not_committed!)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config.middlewares(method, scope: scope), :configure)
                  .with_arguments(&configuration_block)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to delegate_to(config.middlewares(method, scope: scope), :define!)
              end

              specify do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to cache_its_value
              end

              it "returns class middlewares for `method`" do
                expect(config.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
              end
            end

            context "when config is commited" do
              before do
                config.commit!
              end

              it "raises `ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted`" do
                expect { config.middlewares(method, scope: scope, &configuration_block) }
                  .to raise_error(ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted)
                  .with_message(committed_config_error_message)
              end
            end
          end
        end
      end
    end

    describe "#committed?" do
      before do
        ##
        # NOTE: Configures `concerns` in order to cache them.
        #
        config.concerns {}
      end

      specify do
        expect { config.committed? }
          .to delegate_to(config.concerns, :included?)
          .and_return_its_value
      end
    end

    describe "#commit!" do
      before do
        ##
        # NOTE: Configures `concerns` in order to cache them.
        #
        config.concerns {}

        ##
        # NOTE: `include!` returns `true` for the first time, `false` for the subsequent calls.
        #
        config.concerns.include!
      end

      specify do
        expect { config.commit! }
          .to delegate_to(config.concerns, :include!)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
