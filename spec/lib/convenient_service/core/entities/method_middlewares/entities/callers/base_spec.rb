# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { caller_class.new(entity: entity) }
  let(:caller_class) { described_class }

  let(:entity) { double }
  let(:method) { :result }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::AbstractMethod) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { caller }

    it { is_expected.to have_attr_reader(:entity) }
  end

  example_group "abstract methods" do
    include ConvenientService::RSpec::Matchers::HaveAbstractMethod

    subject { caller }

    it { is_expected.to have_abstract_method(:commit_config!) }
    it { is_expected.to have_abstract_method(:ancestors) }
    it { is_expected.to have_abstract_method(:methods_middlewares_callers) }
  end

  example_group "instance methods" do
    # describe "#ancestors_greater_than_methods_middlewares_callers" do
    #   ##
    #   # NOTE: `#ancestors_greater_than_methods_middlewares_callers` is tested in `ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base` descendants.
    #   #
    # end
    #
    # describe "#resolve_super_method" do
    #   ##
    #   # NOTE: `#resolve_super_method` is tested in `ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base` descendants.
    #   #
    # end

    describe "#to_kwargs" do
      let(:kwargs) { {entity: entity} }

      it "returns kwargs representation of caller" do
        expect(caller.to_kwargs).to eq(kwargs)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:caller) { caller_class.new(entity: entity) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns false" do
            expect(caller == other).to be_nil
          end
        end

        context "when `other` has different `entity`" do
          let(:other) { described_class.new(entity: double) }

          it "returns false" do
            expect(caller == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { caller_class.new(entity: entity) }

          it "returns true" do
            expect(caller == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
