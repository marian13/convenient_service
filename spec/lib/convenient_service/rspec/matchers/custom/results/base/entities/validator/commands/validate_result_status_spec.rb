# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator::Commands::ValidateResultStatus do
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
        context "when result status is NOT in chain statuses" do
          let(:matcher) { be_error.tap { |matcher| matcher.matches?(result) } }

          it "return `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when result status is in chain statuses" do
          let(:matcher) { be_success.tap { |matcher| matcher.matches?(result) } }

          it "return `true`" do
            expect(command_result).to eq(true)
          end
        end

        ##
        # NOTE: This case is NOT possible if client uses only public matchers like `be_success`...
        #
        context "when chain status can NOT be casted" do
          let(:matcher) { ConvenientService::RSpec::Matchers::Custom::Results::Base.new(statuses: [chain_status]).tap { |matcher| matcher.matches?(result) } }
          let(:chain_status) { 42 }

          let(:exception_message) do
            <<~TEXT
              Failed to cast `#{chain_status}` into `#{result.class.status_class}`.
            TEXT
          end

          it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
            expect { command_result }
              .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
              .with_message(exception_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
