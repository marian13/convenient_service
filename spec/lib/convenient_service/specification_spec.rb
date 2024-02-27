# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Specification do
  example_group "constants" do
    describe "::VERSION" do
      it "returns name" do
        expect(described_class::NAME).to eq("convenient_service")
      end

      specify { expect(described_class::NAME).to be_frozen }
    end

    describe "::AUTHORS" do
      it "returns authors" do
        expect(described_class::AUTHORS).to eq(["Marian Kostyk"])
      end

      specify { expect(described_class::AUTHORS).to be_frozen }
      specify { expect(described_class::AUTHORS.first).to be_frozen }
    end

    describe "::HOMEPAGE" do
      it "returns homepage" do
        expect(described_class::HOMEPAGE).to eq("https://github.com/marian13/convenient_service")
      end

      specify { expect(described_class::HOMEPAGE).to be_frozen }
    end

    describe "::SUMMARY" do
      it "returns summary" do
        expect(described_class::SUMMARY).to eq(
          <<~TEXT
            Service object pattern implementation in Ruby.
          TEXT
        )
      end

      specify { expect(described_class::SUMMARY).to be_frozen }
    end

    describe "::DESCRIPTION" do
      it "returns description" do
        expect(described_class::DESCRIPTION).to eq(
          <<~TEXT
            Yet another approach to revisit the service object pattern in Ruby, but this time focusing on the unique, opinionated, moderately obtrusive, but not mandatory features.
          TEXT
        )
      end

      specify { expect(described_class::DESCRIPTION).to be_frozen }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
