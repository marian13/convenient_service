# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Enumerable::FindLast, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(enumerable) { |item| item[0] == "b" } }

    context "when `enumerable` does NOT contain `item` to find" do
      let(:enumerable) { ["foo"] }

      it "returns `nil`" do
        expect(util_result).to be_nil
      end
    end

    context "when `enumerable` contains one `item` to find" do
      let(:enumerable) { ["foo", "bar"] }

      it "returns that found `item`" do
        expect(util_result).to eq("bar")
      end
    end

    context "when `enumerable` contains multiple `items` to find" do
      let(:enumerable) { ["foo", "bar", "baz"] }

      it "returns last from those found `items`" do
        expect(util_result).to eq("baz")
      end
    end

    context "when `enumerable` is custom `Enumerable`" do
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

      let(:enumerable) { klass.new }

      it "does NOT use `Array` methods" do
        expect(util_result).to eq("baz")
      end
    end
  end
end
