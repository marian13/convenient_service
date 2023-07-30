# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base::Commands::GenerateGotServicePart do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      context "when matcher is NOT chained by `of_service`" do
        let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `of_service`" do
        let(:matcher) { be_success.of_service(service).tap { |matcher| matcher.matches?(result) } }

        it "returns part with service" do
          expect(command_result).to eq("of service `#{result.service.class}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
