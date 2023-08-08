# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedStatusPart do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      context "when matcher expects one status" do
        let(:matcher) { be_success }

        it "returns part with that one status" do
          expect(command_result).to eq("with `success` status")
        end
      end

      context "when matcher expects multiple statuses" do
        let(:matcher) { be_not_success }

        it "returns part with those multiple statuses" do
          expect(command_result).to eq("with `failure` or `error` status")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
