# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }

    it { is_expected.to include_module(described_class::Concern) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { described_class.new(value: :before) }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "instance methods" do
    let(:type) { described_class.new(value: value) }
    let(:value) { :before }

    describe "#==" do
      context "when types have different classes" do
        let(:other) { "string" }

        it "returns `nil`" do
          expect(type == other).to eq(nil)
        end
      end

      context "when types have different values" do
        let(:other) { described_class.new(value: :after) }

        it "returns `false`" do
          expect(type == other).to eq(false)
        end
      end

      context "when types have same attributes" do
        let(:other) { described_class.new(value: value) }

        it "returns `true`" do
          expect(type == other).to eq(true)
        end
      end
    end

    describe "#eql?" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(type.eql?(other)).to be_nil
        end
      end

      context "when types have different values" do
        let(:other) { described_class.new(value: :after) }

        it "returns `false`" do
          expect(type.eql?(other)).to eq(false)
        end
      end

      context "when types have same attributes" do
        let(:other) { described_class.new(value: value) }

        it "returns `true`" do
          expect(type.eql?(other)).to eq(true)
        end
      end
    end

    describe "#hash" do
      it "returns hash based on class and value" do
        expect(type.hash).to eq([described_class, value].hash)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
