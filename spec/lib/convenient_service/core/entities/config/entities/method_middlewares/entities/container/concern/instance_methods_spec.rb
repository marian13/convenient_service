# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Concern::InstanceMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:container_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:container_instance) { container_class.new(klass: klass) }
  let(:container) { container_instance }

  let(:klass) { service_class }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:service_instance) { service_class.new }

  let(:scope) { :instance }
  let(:method_name) { :result }
  let(:entity) { service_instance }

  let(:concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end

      class_methods do
        def result
        end
      end
    end
  end

  let(:other_concern) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end

      class_methods do
        def result
        end
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { container }

    it { is_expected.to have_attr_reader(:klass) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { container }
  #
  #   it { is_expected.to delegate_method(:ancestors).to(:class) }
  # end

  example_group "instance methods" do
    describe "#super_method_defined?" do
      context "when unbound super method can NOT be resolved" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns `false`" do
          expect(container.super_method_defined?(method_name)).to eq(false)
        end
      end

      context "when unbound super method can be resolved" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern
              end

              middlewares(:result) {}
            end
          end
        end

        before do
          service_class.commit_config!
        end

        it "returns `true`" do
          expect(container.super_method_defined?(method_name)).to eq(true)
        end
      end
    end

    describe "#ancestors_greater_than_methods_middlewares_callers" do
      context "when `service_class` does NOT have `methods_middlewares_callers`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns empty array" do
          expect(container.ancestors_greater_than_methods_middlewares_callers).to eq([])
        end
      end

      context "when `service_class` has `methods_middlewares_callers`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              middlewares(:result) {}
            end
          end
        end

        context "when `ancestors` do NOT contain `methods_middlewares_callers`" do
          let(:klass) { service_class.class }

          it "returns empty array" do
            expect(container.ancestors_greater_than_methods_middlewares_callers).to eq([])
          end
        end

        context "when `ancestors` contains `methods_middlewares_callers`" do
          let(:klass) { service_class }

          specify do
            expect { container.ancestors_greater_than_methods_middlewares_callers }
              .to delegate_to(ConvenientService::Utils::Array, :keep_after)
              .with_arguments(container.ancestors, container.methods_middlewares_callers)
              .and_return_its_value
          end
        end
      end
    end

    describe "#methods_middlewares_callers" do
      specify do
        expect { container.methods_middlewares_callers }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Commands::ResolveMethodsMiddlewaresCallers, :call)
          .with_arguments(container: container)
          .and_return_its_value
      end
    end

    describe "#lock" do
      let(:container_instance) { container_class.new(klass: klass.singleton_class) }

      specify do
        expect { container.lock }
          .to delegate_to(klass.__convenient_service_config__, :lock)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#prepend_methods_callers_to_container" do
      specify do
        expect { container.prepend_methods_callers_to_container }
          .to delegate_to(container.klass, :prepend)
          .with_arguments(container.methods_middlewares_callers)
          .and_return_its_value
      end
    end

    describe "#resolve_unbound_super_method" do
      context "when NO ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns `nil`" do
          expect(container.resolve_unbound_super_method(method_name)).to eq(nil)
        end
      end

      context "when one ancestor from `ancestors_greater_than_methods_middlewares_callers` has own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern
              end

              middlewares(:result) {}
              middlewares(:result, scope: :class) {}
            end
          end
        end

        context "when service class config is NOT committed" do
          it "returns `nil`" do
            expect(container.resolve_unbound_super_method(method_name)).to eq(nil)
          end
        end

        context "when config is committed" do
          before do
            service_class.commit_config!
          end

          context "when container klass is service class" do
            let(:klass) { service_class }

            it "returns unbound own method from concern instance methods" do
              expect(container.resolve_unbound_super_method(method_name)).to eq(concern::InstanceMethods.instance_method(method_name))
            end
          end

          context "when container klass is service class singleton class" do
            let(:klass) { service_class.singleton_class }

            it "returns unbound own method from concern class methods" do
              expect(container.resolve_unbound_super_method(method_name)).to eq(concern::ClassMethods.instance_method(method_name))
            end
          end
        end
      end

      context "when multiple ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern, other_concern) do |concern, other_concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern

                stack.use other_concern
              end

              middlewares(:result) {}
              middlewares(:result, scope: :class) {}
            end
          end
        end

        context "when service class config is NOT committed" do
          it "returns `nil`" do
            expect(container.resolve_unbound_super_method(method_name)).to eq(nil)
          end
        end

        context "when config is committed" do
          before do
            service_class.commit_config!
          end

          context "when container klass is service class" do
            let(:klass) { service_class }

            it "returns unbound own method from lowest of them (closest from inheritance chain) from concern instance methods" do
              expect(container.resolve_unbound_super_method(method_name)).to eq(other_concern::InstanceMethods.instance_method(method_name))
            end
          end

          context "when container klass is service class singleton class" do
            let(:klass) { service_class.singleton_class }

            it "returns unbound own method from lowest of them (closest from inheritance chain) from concern class methods" do
              expect(container.resolve_unbound_super_method(method_name)).to eq(other_concern::ClassMethods.instance_method(method_name))
            end
          end
        end
      end
    end

    describe "#resolve_super_method" do
      context "when unbound super method can NOT be resolved" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core
            end
          end
        end

        it "returns `nil`" do
          expect(container.resolve_super_method(method_name, entity)).to eq(nil)
        end
      end

      context "when unbound super method can be resolved" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(concern) do |concern|
              include ConvenientService::Core

              concerns do |stack|
                stack.use concern
              end

              middlewares(:result) {}
            end
          end
        end

        before do
          service_class.commit_config!
        end

        it "returns super method bound to entity" do
          expect(container.resolve_super_method(method_name, entity)).to eq(concern::InstanceMethods.instance_method(method_name).bind(entity))
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(**kwargs) }
      let(:kwargs) { {klass: container.klass} }

      describe "#to_kwargs" do
        specify do
          allow(container).to receive(:to_arguments).and_return(arguments)

          expect { container.to_kwargs }
            .to delegate_to(container.to_arguments, :kwargs)
            .without_arguments
            .and_return_its_value
        end
      end

      describe "#to_arguments" do
        it "returns arguments representation of container" do
          expect(container.to_arguments).to eq(arguments)
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:container_instance) { container_class.new(klass: klass.singleton_class) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `false`" do
            expect(container == other).to be_nil
          end
        end

        context "when `other` has different `klass`" do
          let(:other) { container_class.new(klass: Class.new) }

          it "returns `false`" do
            expect(container == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { container_class.new(klass: klass.singleton_class) }

          it "returns `true`" do
            expect(container == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
