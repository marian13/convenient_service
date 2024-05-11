# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Null, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:printer) { described_class.new(matcher: be_success) }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base) }
  end

  example_group "instance methods" do
    describe "#description" do
      it "returns empty string" do
        expect(printer.description).to eq("")
      end
    end

    describe "#failure_message" do
      it "returns empty string" do
        expect(printer.failure_message).to eq("")
      end
    end

    describe "#failure_message_when_negated" do
      it "returns empty string" do
        expect(printer.failure_message_when_negated).to eq("")
      end
    end

    describe "#expected_parts" do
      it "returns empty string" do
        expect(printer.expected_parts).to eq("")
      end
    end

    describe "#got_parts" do
      it "returns empty string" do
        expect(printer.got_parts).to eq("")
      end
    end

    describe "#expected_code_part" do
      it "returns empty string" do
        expect(printer.expected_code_part).to eq("")
      end
    end

    describe "#expected_data_part" do
      it "returns empty string" do
        expect(printer.expected_data_part).to eq("")
      end
    end

    describe "#expected_message_part" do
      it "returns empty string" do
        expect(printer.expected_message_part).to eq("")
      end
    end

    describe "#expected_service_part" do
      it "returns empty string" do
        expect(printer.expected_service_part).to eq("")
      end
    end

    describe "#expected_status_part" do
      it "returns empty string" do
        expect(printer.expected_status_part).to eq("")
      end
    end

    describe "#expected_step_part" do
      it "returns empty string" do
        expect(printer.expected_step_part).to eq("")
      end
    end

    describe "#got_step_part" do
      it "returns empty string" do
        expect(printer.got_step_part).to eq("")
      end
    end

    describe "#got_service_part" do
      it "returns empty string" do
        expect(printer.got_service_part).to eq("")
      end
    end

    describe "#got_jsend_attributes_part" do
      it "returns empty string" do
        expect(printer.got_jsend_attributes_part).to eq("")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
