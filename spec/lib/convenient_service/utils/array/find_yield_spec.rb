# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::FindYield do
  describe ".call" do
    subject(:result) { described_class.call(array) { |string| string.match(regex) } }

    let(:regex) { /bar/ }

    context "when array does NOT contain item to find" do
      let(:array) { ["foo"] }

      it "returns `nil`" do
        expect(result).to be_nil
      end
    end

    context "when array contains one item to find" do
      let(:array) { ["foo", "bar"] }
      let(:match_data) { "bar".match(regex) }

      it "returns block value for that one item" do
        expect(result).to eq(match_data)
      end
    end

    context "when array contains multiple items to find" do
      let(:array) { ["foo", "bar first", "bar second"] }
      let(:match_data) { "bar first".match(regex) }

      it "returns block value for first found item" do
        expect(result).to eq(match_data)
      end
    end
  end
end
