# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator::Commands::ValidateResultType do
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

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Commands::IsResult, :call)
            .with_arguments(result: result)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
