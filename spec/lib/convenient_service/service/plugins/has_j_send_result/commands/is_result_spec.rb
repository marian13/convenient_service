# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Commands::IsResult, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result) }

      context "when result does NOT include `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern`" do
        let(:result) { 42 }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end

        specify do
          expect { command_result }
            .to delegate_to(result.class, :include?)
            .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern)
            .and_return_its_value
        end
      end

      context "when result includes `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        let(:result) { service.result }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end

        specify do
          expect { command_result }
            .to delegate_to(result.class, :include?)
            .with_arguments(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
