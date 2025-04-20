# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator::Commands::ValidateResultService, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(validator: matcher.validator) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            error(message: "foo")
          end
        end
      end

      let(:result) { service.result }

      context "when matcher has NO result" do
        let(:matcher) { be_success }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when matcher has result" do
        context "when `of_service` is NOT used" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `of_service` is used" do
          let(:matcher) { be_success.of_service(chain_service).tap { |matcher| matcher.matches?(result) } }

          context "when result service is NOT instance of chain service" do
            let(:chain_service) do
              Class.new do
                include ConvenientService::Standard::Config

                def result
                  success
                end
              end
            end

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end

          context "when result service is instance of chain service" do
            let(:chain_service) { service }

            it "returns `true`" do
              expect(command_result).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
