# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::DefineMethodMiddlewaresCaller do
  let(:command_result) { described_class.call(scope: scope, method: method, container: container) }
  let(:command_instance) { described_class.new(scope: scope, method: method, container: container) }

  let(:scope) { :instance }
  let(:method) { :result }
  let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }
  let(:methods_middlewares_callers) { container.methods_middlewares_callers }
  let(:klass) { service_class }
  let(:service_class) { Class.new }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { command_instance }

    it { is_expected.to have_attr_reader(:scope) }
    it { is_expected.to have_attr_reader(:method) }
    it { is_expected.to have_attr_reader(:container) }
  end

  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::PrependModule

      context "when `scope` is `:instance`" do
        let(:scope) { :instance }
        let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass) }

        context "when `method` is NOT defined in methods middlewares callers" do
          it "prepend methods middlewares callers to container" do
            command_result

            expect(container.klass).to prepend_module(methods_middlewares_callers)
          end

          it "defines `method` middlewares caller" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `method` is defined in methods middlewares callers" do
          before do
            methods_middlewares_callers.define_method(method) {}
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        example_group "generated method" do
          let(:service_instance) { service_class.new }

          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            it "raises `NoMethodError`" do
              expect { service_instance.result }.to raise_error(NoMethodError).with_message("super: no superclass method `result' for #{service_instance}")
            end
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :instance) do
                  middleware = Class.new(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                def result
                  :original_value
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_instance.result).to eq([:middleware_value, :original_value])
            end
          end
        end
      end

      context "when `scope` is `:class`" do
        let(:scope) { :class }
        let(:container) { ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container.new(klass: klass.singleton_class) }

        context "when `method` is NOT defined in methods middlewares callers" do
          it "prepend methods middlewares callers to container" do
            command_result

            expect(container.klass).to prepend_module(methods_middlewares_callers)
          end

          it "defines `method` middlewares caller" do
            expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method, methods_middlewares_callers, private: true) }.from(false).to(true)
          end

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `method` is defined in methods middlewares callers" do
          before do
            methods_middlewares_callers.define_method(method) {}
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        example_group "generated method" do
          context "when super is NOT defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end
              end
            end

            it "raises `NoMethodError`" do
              expect { service_class.result }.to raise_error(NoMethodError).with_message("super: no superclass method `result' for #{service_class}")
            end
          end

          context "when super is defined" do
            let(:service_class) do
              Class.new do
                include ConvenientService::Core

                middlewares(:result, scope: :class) do
                  middleware = Class.new(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware) do
                    def next(...)
                      [:middleware_value, *chain.next(...)]
                    end
                  end

                  use middleware
                end

                class << self
                  def result
                    :original_value
                  end
                end
              end
            end

            it "calls middlewares and super" do
              expect(service_class.result).to eq([:middleware_value, :original_value])
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
