# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Concern::InstanceMethods do
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
  let(:service_class) { Class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { container }

    it { is_expected.to have_attr_reader(:klass) }
  end

  example_group "instance_methods" do
    let(:scope) { :instance }
    let(:method) { :result }

    describe "#methods_middlewares_callers" do
      specify do
        expect { container.methods_middlewares_callers }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Commands::ResolveMethodsMiddlewaresCallers, :call)
          .with_arguments(container: container)
          .and_return_its_value
      end
    end

    describe "define_method_middlewares_caller!" do
      before do
        ##
        # NOTE: Returns `true` when called for the first time, `false` for all the subsequent calls.
        # NOTE: Used for `and_return_its_value`.
        # https://github.com/marian13/convenient_service/blob/c5b3adc4a0edc2d631dd1f44f914c28eeafefe1d/lib/convenient_service/rspec/matchers/custom/delegate_to.rb#L105
        #
        container.define_method_middlewares_caller!(scope, method)
      end

      specify do
        expect { container.define_method_middlewares_caller!(scope, method) }
          .to delegate_to(ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container::Commands::DefineMethodMiddlewaresCaller, :call)
          .with_arguments(scope: scope, method: method, container: container)
          .and_return_its_value
      end
    end

    describe "#prepend_methods_middlewares_callers_to_container" do
      specify do
        expect { container.prepend_methods_middlewares_callers_to_container }
          .to delegate_to(container.klass, :prepend)
          .with_arguments(container.methods_middlewares_callers)
          .and_return_its_value
      end
    end

    describe "#to_kwargs" do
      let(:kwargs_representation) { {klass: container.klass} }

      it "returns kwargs representation of container" do
        expect(container.to_kwargs).to eq(kwargs_representation)
      end
    end

    example_group "comparison" do
      describe "#==" do
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
          let(:other) { container_class.new(klass: klass) }

          it "returns `true`" do
            expect(container == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
