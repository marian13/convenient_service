# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::KeepAfter, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(array, :bar) }

    context "when array does NOT contain item to find" do
      let(:array) { [:foo] }

      it "returns empty array" do
        expect(util_result).to eq([])
      end
    end

    context "when array contains one item to find" do
      let(:array) { [:foo, :bar, :baz] }

      it "returns items after that item exclusively" do
        expect(util_result).to eq([:baz])
      end
    end

    context "when array contains multiple items to find" do
      let(:array) { [:foo, :bar, :foo, :bar] }

      it "returns items after first item from those found items exclusively" do
        expect(util_result).to eq([:foo, :bar])
      end
    end
  end
end
