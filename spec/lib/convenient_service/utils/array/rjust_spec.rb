# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::Rjust, type: :standard do
  describe ".call" do
    subject(:result) { described_class.call(array, size, pad) }

    let(:array) { [:a, :b, :c] }
    let(:pad) { :x }

    context "when `array` size is lower than `size`" do
      let(:size) { 1 }

      it "returns `array`" do
        expect(result).to eq(array)
      end
    end

    context "when `array` size is equal to `size`" do
      let(:size) { 3 }

      it "returns `array`" do
        expect(result).to eq(array)
      end
    end

    context "when `array` size is greater than `size`" do
      let(:size) { 10 }

      it "returns `array` with `size` with `pad` for added items" do
        expect(result).to eq([:a, :b, :c, :x, :x, :x, :x, :x, :x, :x])
      end

      context "when pad is NOT passed" do
        subject(:result) { described_class.call(array, size) }

        it "returns `array` with `size` with `nil` for added items" do
          expect(result).to eq([:a, :b, :c, nil, nil, nil, nil, nil, nil, nil])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
