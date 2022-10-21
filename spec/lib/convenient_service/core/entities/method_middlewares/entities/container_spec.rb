# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:container) { described_class.new(service_class: service_class) }

  let(:service_class) { Class.new }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { container }

    it { is_expected.to have_attr_reader(:service_class) }
  end

  example_group "instance_methods" do
    let(:scope) { :instance }
    let(:method) { :result }

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
          .to delegate_to(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::DefineMethodMiddlewaresCaller, :call)
          .with_arguments(scope: scope, method: method, container: container)
          .and_return_its_value
      end
    end

    describe "resolve_methods_middlewares_callers" do
      specify do
        expect { container.resolve_methods_middlewares_callers(scope) }
          .to delegate_to(ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container::Commands::ResolveMethodsMiddlewaresCallers, :call)
          .with_arguments(scope: scope, container: container)
          .and_return_its_value
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

        context "when `other` has different `service_class`" do
          let(:other) { described_class.new(service_class: Class.new) }

          it "returns `false`" do
            expect(container == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(service_class: service_class) }

          it "returns `true`" do
            expect(container == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
