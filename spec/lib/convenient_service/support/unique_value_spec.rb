# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::UniqueValue do
  let(:unique_value) { described_class.new(label) }
  let(:label) { :foo }
  let(:default_label) { unique_value.object_id.to_s }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { unique_value }

    it { is_expected.to have_attr_reader(:label) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `label` is NOT passed" do
        let(:unique_value) { described_class.new }

        it "defaults to `object_id.to_s`" do
          expect(unique_value.label).to eq(default_label)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#inspect" do
      let(:inspect_representation) { "unique_value_#{label}" }

      it "returns inspect representation with label" do
        expect(unique_value.inspect).to eq(inspect_representation)
      end

      context "when `label` is `nil`" do
        let(:label) { nil }
        let(:inspect_representation) { "unique_value_#{default_label}" }

        it "returns inspect representation with default label" do
          expect(unique_value.inspect).to eq(inspect_representation)
        end
      end

      context "when `label` is empty" do
        let(:label) { "" }
        let(:inspect_representation) { "unique_value_#{default_label}" }

        it "returns inspect representation with default label" do
          expect(unique_value.inspect).to eq(inspect_representation)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
