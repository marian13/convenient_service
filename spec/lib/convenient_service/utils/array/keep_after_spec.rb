# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::KeepAfter, type: :standard do
  describe ".call" do
    subject(:result) { described_class.call(array, :bar) }

    context "when array does NOT contain item to find" do
      let(:array) { [:foo] }

      it "returns empty array" do
        expect(result).to eq([])
      end
    end

    context "when array contains one item to find" do
      let(:array) { [:foo, :bar, :baz] }

      it "returns items after that item exclusively" do
        expect(result).to eq([:baz])
      end
    end

    context "when array contains multiple items to find" do
      let(:array) { [:foo, :bar, :foo, :bar] }

      it "returns items after first item from those found items exclusively" do
        expect(result).to eq([:foo, :bar])
      end
    end
  end
end
