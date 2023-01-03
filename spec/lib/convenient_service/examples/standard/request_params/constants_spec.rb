# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Constants do
  example_group "constants" do
    describe "Tags::EMPTY" do
      it "returns empty string" do
        expect(described_class::Tags::EMPTY).to eq("")
      end
    end
  end
end
