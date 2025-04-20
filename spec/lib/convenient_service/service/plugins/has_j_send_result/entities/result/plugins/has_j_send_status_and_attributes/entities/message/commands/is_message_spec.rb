# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Commands::IsMessage, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(message: message) }

      context "when result does NOT include `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern`" do
        let(:message) { 42 }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when result includes `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error(message: "foo")
            end
          end
        end

        let(:message) { service.result.unsafe_message }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
