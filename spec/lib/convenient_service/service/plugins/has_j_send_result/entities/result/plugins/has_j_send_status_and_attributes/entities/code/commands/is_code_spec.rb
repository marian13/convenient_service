# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Commands::IsCode, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(code: code) }

      context "when result does NOT include `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern`" do
        let(:code) { 42 }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when result includes `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            def result
              success
            end
          end
        end

        let(:code) { service.result.code }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
