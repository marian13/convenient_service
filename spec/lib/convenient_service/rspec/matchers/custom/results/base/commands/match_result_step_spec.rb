# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Commands::MatchResultStep do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(result: result, step: step) }

      context "when step is NOT valid" do
        let(:result) { ConvenientService::Factory.create(:result) }
        let(:step) { ConvenientService::Factory.create(:invalid_step) }

        let(:error_message) do
          <<~TEXT
            Step `#{step}` is NOT valid.

            `of_step` only accepts a Class or a Symbol. For example:

            be_success.of_step(ReadFileContent)
            be_success.of_step(:validate_path)
            be_success.of_step(:result)

            If you need to confirm that `result` has NO step - use `without_step` instead.

            be_success.without_step
          TEXT
        end

        it "raises `ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep`" do
          expect { command_result }
            .to raise_error(ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep)
            .with_message(error_message)
        end
      end

      context "when step is valid" do
        context "when step is service" do
          let(:step) { ConvenientService::Factory.create(:service_step) }

          context "when result has NO step" do
            let(:result) { ConvenientService::Factory.create(:result_without_step) }

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end

          context "when result has step" do
            context "when result step is NOT same as service" do
              let(:result) { ConvenientService::Factory.create(:result_with_service_step) }

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result step is same as service" do
              let(:result) { ConvenientService::Factory.create(:result_with_service_step, service_step: step) }

              it "returns `true`" do
                expect(command_result).to eq(true)
              end
            end
          end
        end

        context "when step is method" do
          context "when step is NOT `:result` method" do
            let(:step) { ConvenientService::Factory.create(:method_step) }

            context "when result has NO step" do
              let(:result) { ConvenientService::Factory.create(:result_without_step) }

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result has step" do
              context "when result step is NOT same as method" do
                let(:result) { ConvenientService::Factory.create(:result_with_method_step) }

                it "returns `false`" do
                  expect(command_result).to eq(false)
                end
              end

              context "when result step is same as method" do
                let(:result) { ConvenientService::Factory.create(:result_with_method_step, method_step: step) }

                it "returns `true`" do
                  expect(command_result).to eq(true)
                end
              end
            end
          end

          context "when step is `:result` method" do
            let(:step) { ConvenientService::Factory.create(:result_method_step) }

            context "when result has NO step" do
              let(:result) { ConvenientService::Factory.create(:result_without_step) }

              it "returns `false`" do
                expect(command_result).to eq(false)
              end
            end

            context "when result has step" do
              context "when result step is NOT `:result` method" do
                let(:result) { ConvenientService::Factory.create(:result_with_method_step) }

                it "returns `false`" do
                  expect(command_result).to eq(false)
                end
              end

              context "when result step is `:result` method" do
                let(:result) { ConvenientService::Factory.create(:result_with_result_method_step) }

                it "returns `true`" do
                  expect(command_result).to eq(true)
                end
              end
            end
          end
        end

        context "when step is `nil`" do
          let(:step) { nil }

          context "when result has NO step" do
            let(:result) { ConvenientService::Factory.create(:result_without_step) }

            it "returns `true`" do
              expect(command_result).to eq(true)
            end
          end

          context "when result has step" do
            let(:result) { ConvenientService::Factory.create(:result_with_step) }

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
