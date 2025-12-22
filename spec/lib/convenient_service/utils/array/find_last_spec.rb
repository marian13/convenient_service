# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::FindLast, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(array) { |item| item[0] == "b" } }

    context "when `array` does NOT contain `item` to find" do
      let(:array) { ["foo"] }

      it "returns `nil`" do
        expect(util_result).to be_nil
      end
    end

    context "when `array` contains one `item` to find" do
      let(:array) { ["foo", "bar"] }

      it "returns that found `item`" do
        expect(util_result).to eq("bar")
      end
    end

    context "when `array` contains multiple `items` to find" do
      let(:array) { ["foo", "bar", "baz"] }

      it "returns last from those found `items`" do
        expect(util_result).to eq("baz")
      end
    end
  end
end
