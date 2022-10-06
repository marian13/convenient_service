# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object do
  describe ".resolve_type" do
    let(:result) { described_class.resolve_type(object) }

    context "when `object` is module" do
      let(:object) { Kernel }

      it "returns `module` string" do
        expect(result).to eq("module")
      end
    end

    context "when `object` is class" do
      let(:object) { Array }

      it "returns `class` string" do
        expect(result).to eq("class")
      end
    end

    context "when `object` is neither module nor class" do
      let(:object) { "foo" }

      it "returns `instance` string" do
        expect(result).to eq("instance")
      end
    end
  end
end
