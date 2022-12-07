# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Constants do
  example_group "constants" do
    describe "Roles::ADMIN" do
      it "returns `:admin`" do
        expect(described_class::Roles::ADMIN).to eq(:admin)
      end
    end

    describe "Roles::GUEST" do
      it "returns `:guest`" do
        expect(described_class::Roles::ADMIN).to eq(:guest)
      end
    end

    describe "Tags::EMPTY" do
      it "returns empty string" do
        expect(described_class::Tags::EMPTY).to eq("")
      end
    end
  end
end
