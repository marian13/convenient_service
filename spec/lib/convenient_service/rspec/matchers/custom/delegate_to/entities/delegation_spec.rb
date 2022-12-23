# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation do
  let(:delegation) { described_class.new(args: args, kwargs: kwargs, block: block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { delegation }

    it { is_expected.to have_attr_reader(:arguments) }
  end

  example_group "class methods" do
    describe "#new" do
      let(:delegation) { described_class.new(args: args, kwargs: kwargs, block: block) }

      it "assigns arguments" do
        expect(delegation.arguments).to eq(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments.new(args: args, kwargs: kwargs, block: block))
      end
    end
  end

  example_group "instance methods" do
    describe "#==" do
      subject(:delegation) { described_class.new(args: args, kwargs: kwargs, block: block) }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(delegation == other).to be_nil
        end
      end

      context "when `other` has different `attributes`" do
        let(:other) { described_class.new(args: [], kwargs: kwargs, block: block) }

        it "returns `false`" do
          expect(delegation == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(args: args, kwargs: kwargs, block: block) }

        it "returns `true`" do
          expect(delegation == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
