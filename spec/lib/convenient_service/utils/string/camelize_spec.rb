# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String::Camelize do
  describe ".call" do
    subject(:result) { described_class.call(string) }

    context "when string do NOT contain any special chars" do
      let(:string) { "foo" }

      it "returns camelized string" do
        expect(result).to eq("Foo")
      end
    end

    context "when string contains colon" do
      let(:string) { "foo:bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains underscore" do
      let(:string) { "foo_bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains question mark" do
      let(:string) { "foo?" }

      it "returns camelized string" do
        expect(result).to eq("Foo")
      end
    end

    context "when string contains dash" do
      let(:string) { "foo-bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains space" do
      let(:string) { "foo bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end
  end
end
