# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::FindLast, type: :standard do
  describe ".call" do
    subject(:result) { described_class.call(array) { |item| item[0] == "b" } }

    context "when `array` does NOT contain `item` to find" do
      let(:array) { ["foo"] }

      it "returns `nil`" do
        expect(result).to be_nil
      end
    end

    context "when `array` contains one `item` to find" do
      let(:array) { ["foo", "bar"] }

      it "returns that found `item`" do
        expect(result).to eq("bar")
      end
    end

    context "when `array` contains multiple `items` to find" do
      let(:array) { ["foo", "bar", "baz"] }

      it "returns last from those found `items`" do
        expect(result).to eq("baz")
      end
    end

    context "when `array` is custom `Enumerable`" do
      let(:klass) do
        Class.new do
          include Enumerable

          def each(&block)
            yield("foo")
            yield("bar")
            yield("baz")

            self
          end
        end
      end

      let(:array) { klass.new }

      it "does NOT use `Array` methods" do
        expect(result).to eq("baz")
      end
    end
  end
end
