# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Commands::AssertKwargsContainOnlyJSendKeys do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(kwargs: kwargs) }

      context "when `kwargs` are empty" do
        let(:kwargs) { {} }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when `kwargs` contain only `data` key" do
        let(:kwargs) { {data: {foo: :bar}} }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when `kwargs` contain only `message` key" do
        let(:kwargs) { {message: "foo"} }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when `kwargs` contain both `data` and `message` keys" do
        let(:kwargs) { {data: {foo: :bar}, message: "foo"} }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when kwargs contain non JSend key" do
        let(:kwargs) { {data: {foo: :bar}, non_jsend_key: anything} }

        let(:error_message) do
          <<~TEXT
            When `kwargs` with `data` key are passed to `failure` method, they can NOT contain non JSend keys like `:non_jsend_key`.

            Please, consider something like:

            failure(foo: :bar) # short version does NOT support custom message
            failure(data: {foo: :bar}) # long version
            failure(data: {foo: :bar}, message: "foo") # long version with custom message
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Errors::KwargsContainNonJSendKey`" do
          expect { command_result }
            .to raise_error(ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Errors::KwargsContainNonJSendKey)
            .with_message(error_message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
