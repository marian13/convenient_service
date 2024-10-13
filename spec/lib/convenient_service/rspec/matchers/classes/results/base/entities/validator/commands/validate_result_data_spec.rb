# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator::Commands::ValidateResultData, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(validator: matcher.validator) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success(data: {foo: :bar})
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
        context "when `with_data` is NOT used" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

          it "returns `true`" do
            expect(command_result).to eq(true)
          end
        end

        context "when `with_data` is used" do
          let(:matcher) { be_success.with_data(chain_data).tap { |matcher| matcher.matches?(result) } }
          let(:chain_data) { 42 }

          context "when `data` is NOT castable" do
            let(:exception_message) do
              <<~TEXT
                Failed to cast `#{chain_data}` into `#{result.class.data_class}`.
              TEXT
            end

            it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
              expect { command_result }
                .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
                .with_message(exception_message)
            end
          end

          context "when `data` is castable" do
            let(:chain_data) { {foo: :bar} }

            context "when result data is NOT same as chain data" do
              let(:matcher) { be_success.with_data(chain_data).tap { |matcher| matcher.matches?(result) } }
              let(:chain_data) { {baz: :qux} }

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result data is same as chain data" do
              let(:matcher) { be_success.with_data(chain_data).tap { |matcher| matcher.matches?(result) } }
              let(:chain_data) { {foo: :bar} }

              it "returns `true`" do
                expect(command_result).to eq(true)
              end
            end

            example_group "`comparing_by` chain" do
              let(:result_data) { result.create_data!(chain_data) }

              context "when `comparing_by` is NOT used" do
                specify do
                  allow(result).to receive(:create_data!).with(chain_data).and_return(result_data)

                  expect { command_result }
                    .to delegate_to(result_data, :==)
                    .with_arguments(result.unsafe_data)
                    .and_return_its_value
                end
              end

              context "when `comparing_by` is used" do
                let(:matcher) { be_success.with_data(chain_data).comparing_by(comparison_method).tap { |matcher| matcher.matches?(result) } }
                let(:comparison_method) { :=== }

                specify do
                  allow(result).to receive(:create_data!).with(chain_data).and_return(result_data)

                  expect { command_result }
                    .to delegate_to(result_data, comparison_method)
                    .with_arguments(result.unsafe_data)
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
