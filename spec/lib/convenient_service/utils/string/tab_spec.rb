# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::String::Tab, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(string, tab_size: tab_size) }

    let(:string) { "foo" }
    let(:tab_size) { 4 }

    context "when `string` is `nil`" do
      let(:string) { nil }

      it "returns empty string" do
        expect(util_result).to eq("")
      end
    end

    context "when `string` is NOT empty" do
      let(:string) { "foo" }

      it "returns `string` with tab" do
        expect(util_result).to eq("    foo")
      end

      context "when `string` has multiple lines" do
        let(:string) { "foo\nbar\nfoo" }

        it "returns `string` with tabs for each line" do
          expect(util_result).to eq("    foo\n    bar\n    foo")
        end
      end

      context "when `string` ends with new line" do
        let(:string) { "foo\nbar\nfoo\n" }

        it "preserves trailing new line" do
          expect(util_result).to eq("    foo\n    bar\n    foo\n")
        end
      end

      context "when `tab_size` is NOT passed" do
        subject(:util_result) { described_class.call(string) }

        let(:string) { "foo\nbar\nfoo\n" }

        it "defaults to `2`" do
          expect(util_result).to eq("  foo\n  bar\n  foo\n")
        end
      end
    end

    context "when `string` is empty" do
      let(:string) { "" }

      it "returns empty string" do
        expect(util_result).to eq("")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
