# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Entities::Tag, type: :standard do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { described_class.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is castable" do
        let(:other) { "ruby" }

        it "returns other casted to caller" do
          expect(casted).to eq(described_class.new(value: other.to_s))
        end
      end
    end
  end

  example_group "instance methods" do
    let(:value) { "ruby" }
    let(:tag) { described_class.cast(value) }

    describe "#to_s" do
      it "returns value" do
        expect(tag.to_s).to eq(value)
      end
    end

    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns false" do
          expect(tag == other).to be_nil
        end
      end

      context "when `other` has different values" do
        let(:other) { described_class.cast("javascript") }

        it "returns true" do
          expect(tag == other).to be(false)
        end
      end

      context "when `other` has same value" do
        let(:other) { described_class.cast(value) }

        it "returns true" do
          expect(tag == other).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
