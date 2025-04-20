# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator::Commands::ValidateResultCode, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(validator: matcher.validator) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            error(message: "foo", code: :foo)
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
        context "when `with_code` is NOT used" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `with_code` is used" do
          let(:matcher) { be_success.with_code(chain_code).tap { |matcher| matcher.matches?(result) } }
          let(:chain_code) { 42 }

          context "when `code` is NOT castable" do
            let(:exception_message) do
              <<~TEXT
                Failed to cast `#{chain_code}` into `#{result.class.code_class}`.
              TEXT
            end

            it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
              expect { command_result }
                .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
                .with_message(exception_message)
            end
          end

          context "when `code` is castable" do
            let(:chain_code) { :foo }

            context "when result code is NOT same as chain code" do
              let(:matcher) { be_success.with_code(chain_code).tap { |matcher| matcher.matches?(result) } }
              let(:chain_code) { :bar }

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result code is same as chain code" do
              let(:matcher) { be_success.with_code(chain_code).tap { |matcher| matcher.matches?(result) } }
              let(:chain_code) { :foo }

              it "returns `true`" do
                expect(command_result).to eq(true)
              end
            end

            example_group "`comparing_by` chain" do
              let(:result_code) { result.create_code!(chain_code) }

              context "when `comparing_by` is NOT used" do
                specify do
                  allow(result).to receive(:create_code!).with(chain_code).and_return(result_code)

                  expect { command_result }
                    .to delegate_to(result_code, :==)
                    .with_arguments(result.unsafe_code)
                    .and_return_its_value
                end
              end

              context "when `comparing_by` is used" do
                let(:matcher) { be_success.with_code(chain_code).comparing_by(comparison_method).tap { |matcher| matcher.matches?(result) } }
                let(:comparison_method) { :=== }

                specify do
                  allow(result).to receive(:create_code!).with(chain_code).and_return(result_code)

                  expect { command_result }
                    .to delegate_to(result_code, comparison_method)
                    .with_arguments(result.unsafe_code)
                    .and_return_its_value
                end
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
