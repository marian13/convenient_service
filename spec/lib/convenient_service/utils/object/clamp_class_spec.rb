# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object::ClampClass do
  describe ".call" do
    let(:util_result) { described_class.call(object) }

    context "when `object` is module" do
      let(:object) { Kernel }

      it "returns that module" do
        expect(util_result).to eq(object)
      end
    end

    context "when `object` is class" do
      let(:object) { Array }

      it "returns that class" do
        expect(util_result).to eq(object)
      end
    end

    context "when `object` is neither module nor class" do
      let(:object) { "foo" }

      it "returns object class" do
        expect(util_result).to eq(object.class)
      end
    end
  end
end
