# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments do
  let(:arguments) { described_class.new(args: args, kwargs: kwargs, block: block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { arguments }

    it { is_expected.to have_attr_reader(:args) }
    it { is_expected.to have_attr_reader(:kwargs) }
    it { is_expected.to have_attr_reader(:block) }
  end

  example_group "class methods" do
    describe "#new" do
      context "when args are NOT passed" do
        let(:arguments) { described_class.new(kwargs: kwargs, block: block) }

        it "defaults to empty array" do
          expect(arguments.args).to eq([])
        end
      end

      context "when kwargs are NOT passed" do
        let(:arguments) { described_class.new(args: args, block: block) }

        it "defaults to empty hash" do
          expect(arguments.kwargs).to eq({})
        end
      end

      context "when block are NOT passed" do
        let(:arguments) { described_class.new(args: args, kwargs: kwargs) }

        it "defaults to `nil`" do
          expect(arguments.block).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#==" do
      subject(:arguments) { described_class.new(**params) }

      let(:params) { {args: [:foo], kwargs: {foo: :bar}, block: proc { :foo }} }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns false" do
          expect(arguments == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(**params.merge(args: [:baz])) }

        it "returns false" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(**params.merge(kwargs: {baz: :qux})) }

        it "returns false" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(**params.merge(block: other_block)) }
        let(:other_block) { proc { :baz } }

        it "returns false" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(**params) }

        it "returns true" do
          expect(arguments == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
