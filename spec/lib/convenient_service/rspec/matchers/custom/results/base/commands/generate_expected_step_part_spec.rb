# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Commands::GenerateExpectedStepPart do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(step: step) }

      context "when step is NOT `nil`" do
        let(:step) { ConvenientService::Factory.create(:step) }

        it "returns expected step part" do
          expect(command_result).to eq("of step `#{step}`")
        end
      end

      context "when step is `nil`" do
        let(:step) { nil }

        it "returns expected step part" do
          expect(command_result).to eq("without step")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
