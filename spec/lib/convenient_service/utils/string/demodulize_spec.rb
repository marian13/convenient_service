# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String::Demodulize do
  describe ".call" do
    subject(:util_result) { described_class.call(string) }

    context "when `string` is `nil`" do
      let(:string) { nil }

      it "returns empty string" do
        expect(util_result).to eq("")
      end
    end

    context "when `string` is empty" do
      let(:string) { "" }

      it "returns empty string" do
        expect(util_result).to eq("")
      end
    end

    context "when `string` does NOT consist of namespaces" do
      let(:string) { "Inflections" }

      it "returns `string`" do
        expect(util_result).to eq("Inflections")
      end
    end

    context "when `string` consist of namespaces" do
      let(:string) { "ActiveSupport::Inflector::Inflections" }

      it "returns last namespace" do
        expect(util_result).to eq("Inflections")
      end
    end

    context "when `string` start with scope resolution operator" do
      let(:string) { "::Inflections" }

      it "removes it from `string`" do
        expect(util_result).to eq("Inflections")
      end
    end
  end
end
