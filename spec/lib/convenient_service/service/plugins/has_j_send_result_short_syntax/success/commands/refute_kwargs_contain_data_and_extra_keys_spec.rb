# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Commands::RefuteKwargsContainDataAndExtraKeys do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(kwargs: kwargs) }

      context "when kwargs do NOT contain `:data` key" do
        let(:kwargs) { {foo: :bar} }

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end

      context "when kwargs contain `:data` key" do
        context "when kwargs do NOT contain extra keys" do
          let(:kwargs) { {data: {foo: :bar}} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when kwargs contain extra keys" do
          let(:kwargs) { {data: {foo: :bar}, extra_key: anything} }

          let(:exception_message) do
            <<~TEXT
              `kwargs` passed to `success` method contain `data` and extra keys. That's NOT allowed.

              Please, consider something like:

              success(foo: :bar)
              success(data: {foo: :bar})
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainDataAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainDataAndExtraKeys)
              .with_message(exception_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
