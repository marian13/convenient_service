# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Commands::GenerateGotStepPart do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result) }

      let(:result) { service.result }

      context "when result has NO step" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            def result
              success
            end
          end
        end

        it "returns got step part" do
          expect(command_result).to eq("without step")
        end
      end

      context "when result has step" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Standard

            step :result

            def result
              success
            end
          end
        end

        it "returns got step part" do
          expect(command_result).to eq("of step `#{result.step.printable_service}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
