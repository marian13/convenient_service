# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Support::Cache::Constants do
  example_group "constants" do
    describe "::Backends::ARRAY" do
      it "returns `:array`" do
        expect(described_class::Backends::ARRAY).to eq(:array)
      end
    end

    describe "::Backends::HASH" do
      it "returns `:hash`" do
        expect(described_class::Backends::HASH).to eq(:hash)
      end
    end

    describe "::Backends::DEFAULT" do
      it "returns `:hash`" do
        expect(described_class::Backends::DEFAULT).to eq(described_class::Backends::HASH)
      end
    end

    describe "::Backends::ALL" do
      it "returns `[:array, :hash]`" do
        expect(described_class::Backends::ALL).to eq([described_class::Backends::ARRAY, described_class::Backends::HASH])
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
