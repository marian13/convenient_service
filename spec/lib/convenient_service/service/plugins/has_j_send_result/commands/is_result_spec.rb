# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Commands::IsResult, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result) }

      let(:result) { service.result }

      context "when result does NOT include `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            middlewares :result do
              delete ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware
            end

            def result
              :foo
            end
          end
        end

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when result includes `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential

            def result
              success
            end
          end
        end

        it "returns `true`" do
          expect(command_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
