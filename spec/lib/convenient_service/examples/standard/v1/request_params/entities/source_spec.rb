# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Entities::Source, type: :standard do
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
        let(:other) { "https://guides.rubyonrails.org/action_controller_overview.html#rescue" }

        it "returns other casted to caller" do
          expect(casted).to eq(described_class.new(value: other.to_s))
        end
      end
    end
  end

  example_group "instance methods" do
    let(:value) { "https://guides.rubyonrails.org/action_controller_overview.html#rescue" }
    let(:source) { described_class.cast(value) }

    describe "#to_s" do
      it "returns value" do
        expect(source.to_s).to eq(value)
      end
    end

    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns false" do
          expect(source == other).to be_nil
        end
      end

      context "when `other` has different values" do
        let(:other) { described_class.cast("https://www.rubyguides.com/2019/07/ruby-instance-variables/") }

        it "returns true" do
          expect(source == other).to eq(false)
        end
      end

      context "when `other` has same value" do
        let(:other) { described_class.cast(value) }

        it "returns true" do
          expect(source == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
