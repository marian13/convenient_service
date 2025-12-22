# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Entities::ID, type: :standard do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { described_class.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { :foo }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is integer" do
        let(:other) { 100_000 }

        it "returns other casted to caller" do
          expect(casted).to eq(described_class.new(value: other.to_s))
        end
      end

      context "when `other` is string" do
        let(:other) { "100000" }

        it "returns other casted to caller" do
          expect(casted).to eq(described_class.new(value: other.to_s))
        end
      end
    end
  end

  example_group "instance methods" do
    let(:value) { "100000" }
    let(:id) { described_class.cast(value) }

    describe "#to_i" do
      it "returns `value.to_i`" do
        expect(id.to_i).to eq(value.to_i)
      end
    end

    describe "#to_s" do
      it "returns value" do
        expect(id.to_s).to eq(value)
      end
    end

    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns false" do
          expect(id == other).to be_nil
        end
      end

      context "when `other` has different values" do
        let(:other) { described_class.cast("1") }

        it "returns true" do
          expect(id == other).to be(false)
        end
      end

      context "when `other` has same value" do
        let(:other) { described_class.cast(value) }

        it "returns true" do
          expect(id == other).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
