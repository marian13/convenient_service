# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedCodePart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      context "when matcher is NOT chained by `with_code`" do
        let(:matcher) { be_success }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `with_code`" do
        let(:matcher) { be_error.with_code(code) }
        let(:code) { :foo }

        it "returns part with code" do
          expect(command_result).to eq("with code `#{code}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
