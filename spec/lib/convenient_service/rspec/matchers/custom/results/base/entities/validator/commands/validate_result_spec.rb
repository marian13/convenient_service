# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator::Commands::ValidateResult do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(validator: matcher.validator) }

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            success
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
        let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

        it "returns `true`" do
          expect(command_result).to eq(true)
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_type?)
            .without_arguments
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_status?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_service?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_step?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_data?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_message?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          expect { command_result }
            .to delegate_to(matcher.validator, :valid_result_code?)
            .without_arguments
            .and_return_its_value
        end

        context "when result has NOT valid type" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(42) } }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_status?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid status" do
          let(:matcher) { be_error.tap { |matcher| matcher.matches?(result) } }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_service?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid service" do
          let(:matcher) { be_success.of_service(other_service).tap { |matcher| matcher.matches?(result) } }

          let(:other_service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                success
              end
            end
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_step?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid step" do
          let(:matcher) { be_success.of_step(step_service).tap { |matcher| matcher.matches?(result) } }

          let(:step_service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                success
              end
            end
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_data?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid data" do
          let(:matcher) { be_success.with_data(data).tap { |matcher| matcher.matches?(result) } }
          let(:data) { {foo: :bar} }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_message?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid message" do
          let(:matcher) { be_error.with_message(message).tap { |matcher| matcher.matches?(result) } }
          let(:message) { "bar" }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                error("foo")
              end
            end
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end

          ##
          # NOTE: Checks whether the following validation is skipped.
          #
          specify do
            expect { command_result }
              .not_to delegate_to(matcher.validator, :valid_result_code?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when result has NOT valid code" do
          let(:matcher) { be_error.with_code(code).tap { |matcher| matcher.matches?(result) } }
          let(:code) { :bar }

          let(:service) do
            Class.new do
              include ConvenientService::Service::Configs::Standard

              def result
                error(message: "foo", code: :foo)
              end
            end
          end

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
