# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Entities::Type do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
    it { is_expected.to extend_module(described_class::ClassMethods) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { described_class.new(value: :before) }

    it { is_expected.to have_attr_reader(:value) }
  end

  example_group "delegators" do
    include Shoulda::Matchers::Independent

    subject { described_class.new(value: :before) }

    it { is_expected.to delegate_method(:hash).to(:value) }
  end

  example_group "instance_methods" do
    let(:type) { described_class.new(value: value) }
    let(:value) { :before }

    describe "#==" do
      context "when types have different classes" do
        let(:other) { "string" }

        it "returns nil" do
          expect(type == other).to eq(nil)
        end
      end

      context "when types have different values" do
        let(:other) { described_class.new(value: :after) }

        it "returns false" do
          expect(type == other).to eq(false)
        end
      end

      context "when types have same attributes" do
        let(:other) { described_class.new(value: value) }

        it "returns true" do
          expect(type == other).to eq(true)
        end
      end
    end

    describe "#eql?" do
      context "when `other' has different class" do
        let(:other) { 42 }

        it "returns `false'" do
          expect(type == other).to be_nil
        end
      end

      context "when types have different hashes" do
        let(:other) { described_class.new(value: :after) }

        it "returns false" do
          expect(type == other).to eq(false)
        end
      end

      context "when types have same hashes" do
        let(:other) { described_class.new(value: value) }

        it "returns true" do
          expect(type == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
