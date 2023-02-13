# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Commands::GenerateGotStepPart do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result) }

      context "when result has NO step" do
        let(:result) { ConvenientService::Factory.create(:result_without_step) }

        it "returns got step part" do
          expect(command_result).to eq("without step")
        end
      end

      context "when step is `nil`" do
        let(:result) { ConvenientService::Factory.create(:result_with_step) }

        it "returns got step part" do
          expect(command_result).to eq("of step `#{result.step.service.klass}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
