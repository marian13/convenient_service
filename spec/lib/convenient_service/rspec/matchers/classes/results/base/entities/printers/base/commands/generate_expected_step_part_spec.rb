# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedStepPart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      context "when matcher is NOT chained by `of_step`" do
        let(:matcher) { be_success }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `of_step`" do
        let(:matcher) { be_error.of_step(step) }

        context "when chain has no step" do
          let(:step) { nil }

          it "returns part without step" do
            expect(command_result).to eq("without step")
          end
        end

        context "when result has step" do
          let(:step) { :foo }

          it "returns part with step" do
            expect(command_result).to eq("of step `#{step}`")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
