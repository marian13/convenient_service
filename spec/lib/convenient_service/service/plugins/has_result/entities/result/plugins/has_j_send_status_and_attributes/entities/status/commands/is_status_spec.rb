# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Commands::IsStatus do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(status: status) }

      context "when result does NOT include `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Concern`" do
        let(:status) { 42 }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when result includes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              success
            end
          end
        end

        let(:status) { service.result.status }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
