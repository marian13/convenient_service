# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Commands::AssertEitherArgsOrKwargsArePassed do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(args: args, kwargs: kwargs) }

      let(:message) { double }
      let(:code) { double }

      context "when args are NOT passed" do
        let(:args) { [] }

        context "when kwargs are NOT passed" do
          let(:kwargs) { {} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when kwargs are passed" do
          let(:kwargs) { {message: message, code: code} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end
      end

      context "when args are passed" do
        let(:args) { [message, code] }

        context "when kwargs are NOT passed" do
          let(:kwargs) { {} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when kwargs are passed" do
          let(:kwargs) { {message: message, code: code} }

          let(:exception_message) do
            <<~TEXT
              Both `args` and `kwargs` are passed to the `error` method.

              Did you mean something like:

              error("Helpful text")
              error("Helpful text", :descriptive_code)

              error(message: "Helpful text")
              error(message: "Helpful text", code: :descriptive_code)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::BothArgsAndKwargsArePassed`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Exceptions::BothArgsAndKwargsArePassed)
              .with_message(exception_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
