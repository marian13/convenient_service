# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::Array::Wrap do
  describe ".call" do
    subject(:result) { described_class.call(object) }

    context "when object is `nil`" do
      let(:object) { nil }

      it "returns empty array" do
        expect(result).to eq([])
      end
    end

    context "when object responds to `to_ary`" do
      let(:object) { OpenStruct.new(to_ary: value) }

      context "when `to_ary` returns falsey value" do
        let(:value) { nil }

        it "returns object inside array" do
          expect(result).to eq([object])
        end
      end

      context "when `to_ary` returns truthy value" do
        let(:value) { [1, 2, 3] }

        it "returns that truthy value" do
          expect(result).to eq(value)
        end
      end
    end

    context "when object is NEITHER nil NOR responds to `to_ary`" do
      let(:object) { "string" }

      it "returns object inside array" do
        expect(result).to eq([object])
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
