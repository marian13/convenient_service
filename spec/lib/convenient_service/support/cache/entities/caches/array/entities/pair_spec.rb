# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Array::Entities::Pair, type: :standard do
  let(:pair) { described_class.new(key: key, value: value) }

  let(:key) { :foo }
  let(:value) { :bar }

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { pair }

    it { is_expected.to have_attr_reader(:key) }
    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "comparison" do
    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(pair == other).to be_nil
        end
      end

      context "when `other` has different `key`" do
        let(:other) { described_class.new(key: :bar, value: value) }

        it "returns `true`" do
          expect(pair == other).to eq(false)
        end
      end

      context "when `other` has different `value`" do
        let(:other) { described_class.new(key: key, value: :foo) }

        it "returns `true`" do
          expect(pair == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(key: key, value: value) }

        it "returns `true`" do
          expect(pair == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
