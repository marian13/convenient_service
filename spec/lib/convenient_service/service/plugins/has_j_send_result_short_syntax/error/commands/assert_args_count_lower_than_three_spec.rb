# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Commands::AssertArgsCountLowerThanThree do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(args: args) }

      let(:message) { double }
      let(:code) { double }

      context "when args count is zero" do
        let(:args) { [] }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when args count is one" do
        let(:args) { [message] }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when args count is two" do
        let(:args) { [message, code] }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when args count is greater than two" do
        let(:args) { [message, code, anything] }

        let(:error_message) do
          <<~TEXT
            More than two `args` are passed to the `error` method.

            Did you mean something like:

            error("Helpful text")
            error("Helpful text", :descriptive_code)
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::MoreThanTwoArgsArePassed`" do
          expect { command_result }
            .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::MoreThanTwoArgsArePassed)
            .with_message(error_message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
