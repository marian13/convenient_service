# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Instance do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { caller_class.new(entity: entity) }
  let(:caller_class) { described_class }

  let(:service_class) do
    Class.new do
      include ConvenientService::Core
    end
  end

  let(:service_instance) { service_class.new }

  let(:entity) { service_instance }
  let(:method_name) { :result }

  let(:mod) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end
    end
  end

  let(:other_mod) do
    Module.new do
      include ConvenientService::Support::Concern

      instance_methods do
        def result
        end
      end
    end
  end

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    describe "#commit_config!" do
      specify do
        expect { caller.commit_config! }
          .to delegate_to(entity.class, :commit_config!)
          .and_return_its_value
      end
    end

    describe "#ancestors" do
      specify do
        expect { caller.ancestors }
          .to delegate_to(entity.class, :ancestors)
          .and_return_its_value
      end
    end

    describe "#methods_middlewares_callers" do
      specify do
        expect { caller.methods_middlewares_callers }
          .to delegate_to(ConvenientService::Utils::Module, :get_own_const)
          .with_arguments(entity.class, :InstanceMethodsMiddlewaresCallers)
          .and_return_its_value
      end
    end

    describe "#ancestors_greater_than_methods_middlewares_callers" do
      context "when `service_class` does NOT have `methods_middlewares_callers`" do
        it "returns empty array" do
          expect(caller.ancestors_greater_than_methods_middlewares_callers).to eq([])
        end
      end

      context "when `service_class` has `methods_middlewares_callers`" do
        context "when `ancestors` do NOT contain `methods_middlewares_callers`" do
          it "returns empty array" do
            expect(caller.ancestors_greater_than_methods_middlewares_callers).to eq([])
          end
        end

        context "when `ancestors` contains `methods_middlewares_callers`" do
          specify do
            expect { caller.ancestors_greater_than_methods_middlewares_callers }
              .to delegate_to(ConvenientService::Utils::Array, :keep_after)
              .with_arguments(caller.ancestors, caller.methods_middlewares_callers)
              .and_return_its_value
          end
        end
      end
    end

    describe "#resolve_super_method" do
      specify do
        expect { caller.resolve_super_method(method_name) }.to delegate_to(caller, :commit_config!)
      end

      context "when NO ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(mod) do |mod|
              include ConvenientService::Core
            end
          end
        end

        it "returns `nil`" do
          expect(caller.resolve_super_method(method_name)).to eq(nil)
        end
      end

      context "when one ancestor from `ancestors_greater_than_methods_middlewares_callers` has own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(mod) do |mod|
              include ConvenientService::Core

              concerns do |stack|
                stack.use mod
              end

              middlewares(:result) {}
            end
          end
        end

        it "returns own method" do
          expect(caller.resolve_super_method(method_name)).to eq(mod::InstanceMethods.instance_method(method_name).bind(service_instance))
        end
      end

      context "when multiple ancestors from `ancestors_greater_than_methods_middlewares_callers` have own method" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(mod, other_mod) do |mod, other_mod|
              include ConvenientService::Core

              concerns do |stack|
                stack.use mod

                stack.use other_mod
              end

              middlewares(:result) {}
            end
          end
        end

        it "returns own method from lowest of them (closest from inheritance chain)" do
          expect(caller.resolve_super_method(method_name)).to eq(other_mod::InstanceMethods.instance_method(method_name).bind(service_instance))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
