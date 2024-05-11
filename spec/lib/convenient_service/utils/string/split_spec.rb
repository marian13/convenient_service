# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::String::Split, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(string, *delimiters) }

    let(:string) { "foo.bar" }
    let(:delimiters) { ["."] }

    context "when `string` is `nil`" do
      let(:string) { nil }
      let(:parts) { [] }

      it "returns empty array" do
        expect(util_result).to eq(parts)
      end
    end

    context "when `string` is empty" do
      let(:string) { "" }
      let(:parts) { [] }

      it "returns empty array" do
        expect(util_result).to eq(parts)
      end
    end

    context "when NO `delimiters` are passed" do
      let(:delimiters) { [] }
      let(:parts) { [string] }

      it "returns array with `string`" do
        expect(util_result).to eq(parts)
      end
    end

    context "when one `delimiter` is passed" do
      let(:delimiters) { ["."] }

      context "when `string` does NOT contain that `delimeter`" do
        let(:string) { "foo" }
        let(:parts) { ["foo"] }

        it "returns array with `string`" do
          expect(util_result).to eq(parts)
        end
      end

      context "when `string` contains that `delimeter`" do
        let(:string) { "foo.bar" }
        let(:parts) { ["foo", "bar"] }

        it "returns array with `string` split by that `delimeter`" do
          expect(util_result).to eq(parts)
        end
      end
    end

    context "when multiple `delimiters` are passed" do
      let(:delimiters) { [".", "::"] }

      context "when `string` does NOT contain all those `delimeters`" do
        let(:string) { "foo" }
        let(:parts) { ["foo"] }

        it "returns array with `string`" do
          expect(util_result).to eq(parts)
        end
      end

      context "when `string` contain any of those `delimeters`" do
        let(:string) { "foo.bar" }
        let(:parts) { ["foo", "bar"] }

        it "returns array with `string` split by that `delimeter`" do
          expect(util_result).to eq(parts)
        end
      end

      context "when `string` contain all those `delimeters`" do
        let(:string) { "foo.bar::baz" }
        let(:parts) { ["foo", "bar", "baz"] }

        it "returns array with `string` split by those `delimeters`" do
          expect(util_result).to eq(parts)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
