# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::IgnoringException do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(error, &block) }
      let(:error) { Class.new(StandardError) }

      context "when `error` is NOT raised" do
        let(:block) { proc {} }

        let(:error_message) do
          <<~TEXT
            Error `#{error}` is NOT raised. That is why it is NOT ignored.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Custom::IgnoringException::Exceptions::IgnoredErrorIsNotRaised`" do
          expect { command_result }
            .to raise_error(ConvenientService::RSpec::Helpers::Custom::IgnoringException::Exceptions::IgnoredErrorIsNotRaised)
            .with_message(error_message)
        end
      end

      context "when `error` is raised" do
        let(:block) { proc { raise error } }

        it "returns `ConvenientService::Support::UNDEFINED`" do
          expect(command_result).to eq(ConvenientService::Support::UNDEFINED)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
