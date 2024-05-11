# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedDataPart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      context "when matcher is NOT chained by `with_data`" do
        let(:matcher) { be_success }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `with_data`" do
        let(:matcher) { be_error.with_data(data) }
        let(:data) { {foo: :bar} }

        it "returns part with data" do
          expect(command_result).to eq("with data `#{data}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
