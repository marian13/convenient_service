# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::String::Truncate do
  describe ".call" do
    let(:string) { "hello" }
    let(:omission) { "..." }

    let(:util_results) { (-1..7).map { |truncate_at| described_class.call(string, truncate_at, omission: "...") } }

    let(:truncated_strings) {
      [
        "",
        "",
        ".",
        "..",
        "...",
        "h...",
        "hello",
        "hello",
        "hello"
      ]
    }

    it "returns truncated string" do
      expect(util_results).to eq(truncated_strings)
    end

    context "when `omission` is NOT passed" do
      it "defaults to `...`" do
        expect(described_class.call(string, 4)).to eq("h...")
      end
    end

    context "when `string` is NOT string" do
      it "converts it to string" do
        expect(described_class.call(10000, 4, omission: omission)).to eq("1...")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
