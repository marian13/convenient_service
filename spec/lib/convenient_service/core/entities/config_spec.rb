# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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

  let(:middleware) do
    Class.new(ConvenientService::MethodChainMiddleware) do
      def next(...)
        :middleware_value
      end
    end
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { config }

    it { is_expected.to have_attr_reader(:klass) }
  end

  example_group "class methods" do
    describe ".new" do
      specify do
        expect { config }
          .to delegate_to(Mutex, :new)
          .without_arguments
      end
    end
  end

  example_group "instance methods" do
    describe "#lock" do
      it "returns `Mutex` instance" do
        expect(config.lock).to be_instance_of(Mutex)
      end

      specify do
        expect { config.lock }.to cache_its_value
      end

      specify do
        config

        expect { config.lock }.not_to delegate_to(Mutex, :new)
      end
    end

    describe "#concerns" do
      context "when `configuration_block` is NOT passed" do
        let(:concerns) { described_class::Entities::Concerns.new(klass: service_class) }

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
        let(:concerns) { described_class::Entities::Concerns.new(klass: service_class).configure(&configuration_block) }
        let(:configuration_block) { proc { |stack| stack.use concern } }

        context "when config is NOT committed" do
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

        context "when config is committed" do
          before do
            config.commit!
          end

          it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
            expect { config.concerns(&configuration_block) }
              .to raise_error(described_class::Exceptions::ConfigIsCommitted)
              .with_message(committed_config_error_message)
          end

          specify do
            expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.concerns(&configuration_block) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end

    describe "#middlewares" do
      let(:method) { :result }

      context "when `configuration_block` is NOT passed" do
        let(:result) { config.middlewares(method, **kwargs) }

        context "when middlewares are NOT configured" do
          let(:instance_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :instance, method: method, klass: service_class) }
          let(:class_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :class, method: method, klass: service_class) }

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
          context "when NO middlewares are left after that configuration" do
            let(:instance_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :instance, method: method, klass: service_class) }
            let(:class_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :class, method: method, klass: service_class) }

            context "when `scope` is NOT passed" do
              before do
                config.middlewares(method) {}
              end

              specify { expect { config.middlewares(method) }.not_to cache_its_value }

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method)).to eq(instance_method_middlewares)
              end
            end

            context "when `scope` is passed" do
              context "when `scope` is `:instance`" do
                before do
                  config.middlewares(method, scope: :instance) {}
                end

                specify { expect { config.middlewares(method, scope: :instance) }.not_to cache_its_value }

                it "returns instance middlewares for `method`" do
                  expect(config.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
                end
              end

              context "when `scope` is `:class`" do
                before do
                  config.middlewares(method, scope: :class) {}
                end

                specify { expect { config.middlewares(method, scope: :class) }.not_to cache_its_value }

                it "returns class middlewares for `method`" do
                  expect(config.middlewares(method, scope: :class)).to eq(class_method_middlewares)
                end
              end
            end
          end

          context "when at least one middleware is left after that configuration" do
            let(:instance_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :instance, method: method, klass: service_class).configure { |stack| stack.use middleware } }
            let(:class_method_middlewares) { described_class::Entities::MethodMiddlewares.new(scope: :class, method: method, klass: service_class).configure { |stack| stack.use middleware } }

            context "when `scope` is NOT passed" do
              before do
                config.middlewares(method) do |stack|
                  stack.use middleware
                end
              end

              specify { expect { config.middlewares(method) }.to cache_its_value }

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method)).to eq(instance_method_middlewares)
              end
            end

            context "when `scope` is passed" do
              context "when `scope` is `:instance`" do
                before do
                  config.middlewares(method, scope: :instance) do |stack|
                    stack.use middleware
                  end
                end

                specify { expect { config.middlewares(method, scope: :instance) }.to cache_its_value }

                it "returns instance middlewares for `method`" do
                  expect(config.middlewares(method, scope: :instance)).to eq(instance_method_middlewares)
                end
              end

              context "when `scope` is `:class`" do
                before do
                  config.middlewares(method, scope: :class) do |stack|
                    stack.use middleware
                  end
                end

                specify { expect { config.middlewares(method, scope: :class) }.to cache_its_value }

                it "returns class middlewares for `method`" do
                  expect(config.middlewares(method, scope: :class)).to eq(class_method_middlewares)
                end
              end
            end
          end
        end
      end

      context "when `configuration_block` is passed" do
        context "when NO middlewares are left after configuration" do
          let(:instance_method_configuration_block) { proc { |stack| stack.remove middleware if stack.has?(middleware) } }
          let(:class_method_configuration_block) { proc { |stack| stack.remove middleware if stack.has?(middleware) } }

          let(:instance_method_middlewares) do
            described_class::Entities::MethodMiddlewares
              .new(scope: :instance, method: method, klass: service_class)
              .configure { |stack| stack.use middleware }
              .configure(&instance_method_configuration_block)
          end

          let(:class_method_middlewares) do
            described_class::Entities::MethodMiddlewares
              .new(scope: :class, method: method, klass: service_class)
              .configure { |stack| stack.use middleware }
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
                config.middlewares(method) do |stack|
                  stack.use middleware
                end
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
                  .to delegate_to(config.middlewares(method), :undefine!)
              end

              specify do
                expect { config.middlewares(method, &configuration_block) }
                  .not_to cache_its_value
              end

              it "returns instance middlewares for `method`" do
                expect(config.middlewares(method, &configuration_block)).to eq(method_middlewares)
              end
            end

            context "when config is committed" do
              before do
                config.commit!
              end

              it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                expect { config.middlewares(method, &configuration_block) }
                  .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                  .with_message(committed_config_error_message)
              end

              specify do
                expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, &configuration_block) } }
                  .to delegate_to(ConvenientService, :raise)
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
                  config.middlewares(method, scope: scope) do |stack|
                    stack.use middleware
                  end
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
                    .to delegate_to(config.middlewares(method, scope: scope), :undefine!)
                end

                specify do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .not_to cache_its_value
                end

                it "returns instance middlewares for `method`" do
                  expect(config.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
                end
              end

              context "when config is committed" do
                before do
                  config.commit!
                end

                it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                    .with_message(committed_config_error_message)
                end

                specify do
                  expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, scope: scope, &configuration_block) } }
                    .to delegate_to(ConvenientService, :raise)
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
                  config.middlewares(method, scope: scope) do |stack|
                    stack.use middleware
                  end
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
                    .to delegate_to(config.middlewares(method, scope: scope), :undefine!)
                end

                specify do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .not_to cache_its_value
                end

                it "returns class middlewares for `method`" do
                  expect(config.middlewares(method, scope: scope, &configuration_block)).to eq(method_middlewares)
                end
              end

              context "when config is committed" do
                before do
                  config.commit!
                end

                it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                    .with_message(committed_config_error_message)
                end

                specify do
                  expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, scope: scope, &configuration_block) } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end
        end

        context "when at least one middleware is left after configuration" do
          let(:instance_method_middleware) do
            Class.new(ConvenientService::MethodChainMiddleware) do
              def next(...)
                chain.next(...)
              end
            end
          end

          let(:class_method_middleware) do
            Class.new(ConvenientService::MethodChainMiddleware) do
              def next(...)
                chain.next(...)
              end
            end
          end

          let(:instance_method_configuration_block) { proc { |stack| stack.use instance_method_middleware } }
          let(:class_method_configuration_block) { proc { |stack| stack.use class_method_middleware } }

          let(:instance_method_middlewares) do
            described_class::Entities::MethodMiddlewares
              .new(scope: :instance, method: method, klass: service_class)
              .configure { |stack| stack.use middleware }
              .configure(&instance_method_configuration_block)
          end

          let(:class_method_middlewares) do
            described_class::Entities::MethodMiddlewares
              .new(scope: :class, method: method, klass: service_class)
              .configure { |stack| stack.use middleware }
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
                config.middlewares(method) do |stack|
                  stack.use middleware
                end
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

            context "when config is committed" do
              before do
                config.commit!
              end

              it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                expect { config.middlewares(method, &configuration_block) }
                  .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                  .with_message(committed_config_error_message)
              end

              specify do
                expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, &configuration_block) } }
                  .to delegate_to(ConvenientService, :raise)
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
                  config.middlewares(method, scope: scope) do |stack|
                    stack.use middleware
                  end
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

              context "when config is committed" do
                before do
                  config.commit!
                end

                it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                    .with_message(committed_config_error_message)
                end

                specify do
                  expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, scope: scope, &configuration_block) } }
                    .to delegate_to(ConvenientService, :raise)
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
                  config.middlewares(method, scope: scope) do |stack|
                    stack.use middleware
                  end
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

              context "when config is committed" do
                before do
                  config.commit!
                end

                it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
                  expect { config.middlewares(method, scope: scope, &configuration_block) }
                    .to raise_error(described_class::Exceptions::ConfigIsCommitted)
                    .with_message(committed_config_error_message)
                end

                specify do
                  expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.middlewares(method, scope: scope, &configuration_block) } }
                    .to delegate_to(ConvenientService, :raise)
                end
              end
            end
          end
        end
      end
    end

    # rubocop:disable RSpec/ExampleLength
    describe "#options" do
      context "when called on `entity`" do
        context "when called before `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                service_options = options

                example.instance_exec(service_options) do |service_options|
                  expect(service_options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                service_options = options
                cached_service_options = options

                example.instance_exec(service_options, cached_service_options) do |service_options, cached_service_options|
                  expect(service_options.object_id).to eq(cached_service_options.object_id)
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called inside `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    service_options = options

                    example.instance_exec(service_options) do |service_options|
                      expect(service_options).to eq(ConvenientService::Config::Commands::NormalizeOptions.call(options: [:foo, :bar]))
                    end
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    service_options = options
                    cached_service_options = options

                    example.instance_exec(service_options, cached_service_options) do |service_options, cached_service_options|
                      expect(service_options.object_id).to eq(cached_service_options.object_id)
                    end
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called after `config` module" do
          let(:service_config) { service_class.__convenient_service_config__ }

          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              Module.new do
                include ConvenientService::Config

                default_options do
                  [:foo, :bar]
                end
              end
            end
          end

          it "returns empty set" do
            expect(service_config.options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
          end

          specify do
            expect { service_config.options }.to cache_its_value
          end
        end
      end

      context "when called on nested `entity`" do
        context "when called before `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                entity :Result do
                  result_options = options

                  example.instance_exec(result_options) do |result_options|
                    expect(result_options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                service_options = options

                entity :Result do
                  result_options = options

                  example.instance_exec(service_options, result_options) do |service_options, result_options|
                    expect(result_options.object_id).to eq(service_options.object_id)
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                entity :Result do
                  result_options = options
                  cached_result_options = options

                  example.instance_exec(result_options, cached_result_options) do |result_options, cached_result_options|
                    expect(result_options.object_id).to eq(cached_result_options.object_id)
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called inside `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    entity :Result do
                      result_options = options

                      example.instance_exec(result_options) do |result_options|
                        expect(result_options).to eq(ConvenientService::Config::Commands::NormalizeOptions.call(options: [:foo, :bar]))
                      end
                    end
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    service_options = options

                    entity :Result do
                      result_options = options

                      example.instance_exec(service_options, result_options) do |service_options, result_options|
                        expect(result_options.object_id).to eq(service_options.object_id)
                      end
                    end
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    entity :Result do
                      result_options = options
                      cached_result_options = options

                      example.instance_exec(result_options, cached_result_options) do |result_options, cached_result_options|
                        expect(result_options.object_id).to eq(cached_result_options.object_id)
                      end
                    end
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called after `config` module" do
          let(:service_config) { service_class.__convenient_service_config__ }
          let(:result_config) { service_class::Result.__convenient_service_config__ }

          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              entity :Result do
              end
            end
          end

          it "returns empty set" do
            expect(result_config.options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
          end

          it "returns same set as `entity`" do
            expect(result_config.options.object_id).to eq(service_config.options.object_id)
          end

          specify do
            expect { result_config.options }.to cache_its_value
          end
        end
      end

      context "when called on multiple times nested `entity`" do
        context "when called before `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                entity :Result do
                  entity :Data do
                    data_options = options

                    example.instance_exec(data_options) do |data_options|
                      expect(data_options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
                    end
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as one time nested `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                entity :Result do
                  result_options = options

                  entity :Data do
                    data_options = options

                    example.instance_exec(result_options, data_options) do |result_options, data_options|
                      expect(data_options.object_id).to eq(result_options.object_id)
                    end
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                service_options = options

                entity :Result do
                  entity :Data do
                    data_options = options

                    example.instance_exec(service_options, data_options) do |service_options, data_options|
                      expect(data_options.object_id).to eq(service_options.object_id)
                    end
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                include ConvenientService::Core

                entity :Result do
                  entity :Data do
                    data_options = options
                    cached_data_options = options

                    example.instance_exec(data_options, cached_data_options) do |data_options, cached_data_options|
                      expect(data_options.object_id).to eq(cached_data_options.object_id)
                    end
                  end
                end

                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called inside `config` module" do
          it "returns `config` module options" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    entity :Result do
                      entity :Data do
                        data_options = options

                        example.instance_exec(data_options) do |data_options|
                          expect(data_options).to eq(ConvenientService::Config::Commands::NormalizeOptions.call(options: [:foo, :bar]))
                        end
                      end
                    end
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as one time nested `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    entity :Result do
                      result_options = options

                      entity :Data do
                        data_options = options

                        example.instance_exec(result_options, data_options) do |result_options, data_options|
                          expect(data_options.object_id).to eq(result_options.object_id)
                        end
                      end
                    end
                  end
                end

                include mod
              end
            end
          end

          it "returns same options as `entity`" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    service_options = options

                    entity :Result do
                      entity :Data do
                        data_options = options

                        example.instance_exec(service_options, data_options) do |service_options, data_options|
                          expect(data_options.object_id).to eq(service_options.object_id)
                        end
                      end
                    end
                  end
                end

                include mod
              end
            end
          end

          it "caches its value" do
            Class.new.tap do |klass|
              klass.class_exec(self) do |example|
                mod = Module.new do
                  include ConvenientService::Config

                  default_options do
                    [:foo, :bar]
                  end

                  included do
                    entity :Result do
                      result_options = options
                      cached_result_options = options

                      example.instance_exec(result_options, cached_result_options) do |result_options, cached_result_options|
                        expect(result_options.object_id).to eq(cached_result_options.object_id)
                      end
                    end
                  end
                end

                include mod
              end
            end
          end
        end

        context "when called after `config` module" do
          let(:service_config) { service_class.__convenient_service_config__ }
          let(:result_config) { service_class::Result.__convenient_service_config__ }
          let(:data_config) { service_class::Result::Data.__convenient_service_config__ }

          let(:service_class) do
            Class.new do
              include ConvenientService::Core

              entity :Result do
                entity :Data do
                end
              end
            end
          end

          it "returns empty set" do
            expect(data_config.options).to eq(ConvenientService::Config::Entities::OptionCollection.new)
          end

          it "returns same set as one time nested `entity`" do
            expect(data_config.options.object_id).to eq(result_config.options.object_id)
          end

          it "returns same set as `entity`" do
            expect(data_config.options.object_id).to eq(service_config.options.object_id)
          end

          specify do
            expect { data_config.options }.to cache_its_value
          end
        end
      end
    end
    # rubocop:enable RSpec/ExampleLength

    describe "#entity" do
      let(:name) { :Result }

      context "when `configuration_block` is NOT passed" do
        specify do
          expect { config.entity(name) }
            .to delegate_to(ConvenientService::Core::Entities::Config::Commands::FindEntityClass, :call)
            .with_arguments(config: config, name: name)
            .and_return_its_value
        end
      end

      context "when `configuration_block` is passed" do
        let(:configuration_block) do
          proc do
            concerns do
              use Module.new
            end
          end
        end

        context "when `config` is NOT committed" do
          specify do
            expect { config.entity(name, &configuration_block) }
              .to delegate_to(ConvenientService::Core::Entities::Config::Commands::FindOrCreateEntityClass, :call)
              .with_arguments(config: config, name: name)
              .and_return_its_value
          end

          it "evalutes `configuration_block` in `entity` context" do
            ##
            # NOTE: Defines entity class.
            #
            config.entity(name) do
            end

            expect { config.entity(name, &configuration_block) }.to change { config.entity(name).concerns.to_a.size }.from(0).to(1)
          end

          context "when `configuration_block` calls nested `entity`" do
            let(:nested_name) { :Data }

            let(:configuration_block) do
              proc do
                entity :Data do
                  concerns do
                    use Module.new
                  end
                end
              end
            end

            it "evalutes nested `configuration_block` in nested`entity` context" do
              ##
              # NOTE: Defines entity class.
              #
              config.entity(name) do
                entity :Data do
                end
              end

              expect { config.entity(name, &configuration_block) }.to change { config.entity(name).entity(nested_name).concerns.to_a.size }.from(0).to(1)
            end
          end
        end

        context "when `config` is committed" do
          before do
            config.commit!
          end

          it "raises `ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted`" do
            expect { config.entity(name, &configuration_block) }
              .to raise_error(described_class::Exceptions::ConfigIsCommitted)
              .with_message(committed_config_error_message)
          end

          specify do
            expect { ignoring_exception(described_class::Exceptions::ConfigIsCommitted) { config.entity(name, &configuration_block) } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end

    describe "#method_missing_commits_counter" do
      it "returns `ConvenientService::Support::ThreadSafeCounter` instance" do
        expect(config.method_missing_commits_counter).to be_instance_of(ConvenientService::Support::ThreadSafeCounter)
      end

      specify do
        expect { config.method_missing_commits_counter }.to cache_its_value
      end

      example_group "`counter`" do
        it "has initial value set to `0`" do
          expect(config.method_missing_commits_counter.current_value).to eq(0)
        end

        it "has current value same as initial value" do
          expect(config.method_missing_commits_counter.current_value).to eq(config.method_missing_commits_counter.initial_value)
        end

        it "has max value set to `ConvenientService::Core::Constants::Commits::METHOD_MISSING_MAX_TRIES`" do
          expect(config.method_missing_commits_counter.max_value).to eq(ConvenientService::Core::Constants::Commits::METHOD_MISSING_MAX_TRIES)
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

      context "when config is NOT committed" do
        specify do
          expect { config.committed? }
            .to delegate_to(config.concerns, :included?)
            .and_return_its_value
        end

        it "returns `false`" do
          expect(config.committed?).to eq(false)
        end

        context "when called multiple times" do
          before do
            config.committed?
          end

          specify do
            expect { config.committed? }
              .to delegate_to(config.concerns, :included?)
              .and_return_its_value
          end
        end
      end

      context "when config is committed" do
        before do
          config.commit!
        end

        specify do
          expect { config.committed? }
            .to delegate_to(config.concerns, :included?)
            .and_return_its_value
        end

        it "returns `true`" do
          expect(config.committed?).to eq(true)
        end

        context "when called multiple times" do
          before do
            config.committed?
          end

          specify do
            expect { config.committed? }.not_to delegate_to(config.concerns, :included?)
          end
        end
      end
    end

    describe "#commit!" do
      before do
        ##
        # NOTE: Configures `concerns` in order to cache them.
        #
        config.concerns {}
      end

      context "when concerns are NOT included" do
        specify do
          expect { config.commit! }.to delegate_to(config.concerns, :include!)
        end

        specify do
          expect { config.commit! }
            .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
            .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::USER)
        end

        it "returns `true`" do
          expect(config.commit!).to eq(true)
        end

        context "when called multiple times" do
          before do
            config.commit!
          end

          specify do
            expect { config.commit! }.not_to delegate_to(config.concerns, :include!)
          end

          specify do
            expect { config.commit! }
              .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
              .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::USER)
          end

          it "returns `false`" do
            expect(config.commit!).to eq(false)
          end
        end
      end

      context "when concerns are included" do
        before do
          ##
          # NOTE: `include!` returns `true` for the first time, `false` for the subsequent calls.
          #
          config.concerns.include!
        end

        specify do
          expect { config.commit! }.not_to delegate_to(config.concerns, :include!)
        end

        specify do
          expect { config.commit! }
            .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
            .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::USER)
        end

        it "returns `false`" do
          expect(config.commit!).to eq(false)
        end

        context "when called multiple times" do
          before do
            config.commit!
          end

          specify do
            expect { config.commit! }.not_to delegate_to(config.concerns, :include!)
          end

          specify do
            expect { config.commit! }
              .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
              .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::USER)
          end

          it "returns `false`" do
            expect(config.commit!).to eq(false)
          end
        end
      end

      example_group "`trigger` option" do
        context "when `trigger` is NOT passed" do
          it "defaults `ConvenientService::Core::Constants::Triggers::USER`" do
            expect { config.commit! }
              .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
              .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::USER)
          end
        end

        context "when `trigger` is passed" do
          specify do
            expect { config.commit!(trigger: ConvenientService::Core::Constants::Triggers::INSTANCE_METHOD_MISSING) }
              .to delegate_to(described_class::Commands::TrackMethodMissingCommitTrigger, :call)
              .with_arguments(config: config, trigger: ConvenientService::Core::Constants::Triggers::INSTANCE_METHOD_MISSING)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
