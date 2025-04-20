# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Commands::IsStep, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(step: step) }

      context "when `step` class does NOT include `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Concern`" do
        let(:step) { 42 }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when `step` class includes `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Concern`" do
        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            step :result

            def result
              success
            end
          end
        end

        let(:step) { service.new.steps.first }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
