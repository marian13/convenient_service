# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Hash::Except do
  describe ".call" do
    let(:hash) { {foo: "foo", bar: "bar", baz: "baz"} }
    let(:result) { described_class.call(hash, keys) }

    context "when hash does NOT contain any key from `keys`" do
      let(:keys) { [:qux] }

      it "returns hash with same keys as original hash" do
        expect(result.keys).to eq(hash.keys)
      end

      it "copies hash" do
        expect(result.object_id).not_to eq(hash.object_id)
      end
    end

    context "when hash contain single key from `keys`" do
      let(:keys) { [:baz] }

      it "returns hash without that key" do
        expect(result.keys).to eq(hash.keys - keys)
      end

      it "copies hash" do
        expect(result.object_id).not_to eq(hash.object_id)
      end
    end

    context "when hash contain multiple keys from `keys`" do
      let(:keys) { [:foo, :baz] }

      it "returns hash without those keys" do
        expect(result.keys).to eq(hash.keys - keys)
      end

      it "copies hash" do
        expect(result.object_id).not_to eq(hash.object_id)
      end
    end
  end
end
