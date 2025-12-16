# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::LimitedPush, type: :standard do
  example_group "constants" do
    describe "DEFAULT_MAX_SERVICES_SIZE" do
      it "returns `1_000`" do
        expect(described_class::Constants::DEFAULT_LIMIT).to eq(1_000)
      end
    end
  end

  example_group "class methods" do
    describe ".call" do
      subject(:util_result) { described_class.call(array, object, limit: limit) }

      let(:array) { [:foo, :bar] }
      let(:object) { :baz }
      let(:limit) { 10 }

      context "when `array` size is lower than `limit`" do
        let(:limit) { 1 }

        it "does NOT push `object` to array" do
          expect(util_result).to eq([:foo, :bar])
        end

        it "returns modified original array" do
          expect(util_result).to equal(array)
        end
      end

      context "when `array` size is equal to `limit`" do
        let(:limit) { 2 }

        it "does NOT push `object` to array" do
          expect(util_result).to eq([:foo, :bar])
        end

        it "returns modified original array" do
          expect(util_result).to equal(array)
        end
      end

      context "when `array` size is greater than `limit`" do
        let(:limit) { 3 }

        it "pushes `object` to array" do
          expect(util_result).to eq([:foo, :bar, :baz])
        end

        it "returns modified original array" do
          expect(util_result).to equal(array)
        end
      end

      context "when `limit` is NOT passed" do
        subject(:util_result) { described_class.call(array, object) }

        before do
          stub_const("ConvenientService::Utils::Array::LimitedPush::Constants::DEFAULT_LIMIT", 0)
        end

        it "defaults to `ConvenientService::Utils::Array::LimitedPush::Constants::DEFAULT_LIMIT`" do
          expect(util_result).to eq([:foo, :bar])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
