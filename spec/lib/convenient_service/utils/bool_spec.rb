# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool do
  describe "#to_bool" do
    subject(:result) { described_class.to_bool(object) }

    context "when object is falsey" do
      let(:object) { nil }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when object is truthy" do
      let(:object) { 42 }

      it "returns true" do
        expect(result).to eq(true)
      end
    end
  end
end
