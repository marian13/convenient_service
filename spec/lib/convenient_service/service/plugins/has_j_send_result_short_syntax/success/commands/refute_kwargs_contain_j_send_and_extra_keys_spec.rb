# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Commands::RefuteKwargsContainJSendAndExtraKeys, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(kwargs: kwargs) }

      context "when `kwargs` do NOT contain `:data`, `:message` and `code` keys" do
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
              `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form. Assumes that all kwargs are `data`.
              success(foo: :bar)

              # Longer form. More explicit.
              success(data: {foo: :bar})

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
              success(data: {foo: :bar}, message: "foo")
              success(data: {foo: :bar}, code: :foo)
              success(data: {foo: :bar}, message: "foo", code: :foo)
              success(message: "foo")
              success(code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys) { command_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end

      context "when kwargs contain `:message` key" do
        context "when kwargs do NOT contain extra keys" do
          let(:kwargs) { {message: "foo"} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when kwargs contain extra keys" do
          let(:kwargs) { {message: "foo", extra_key: anything} }

          let(:exception_message) do
            <<~TEXT
              `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form. Assumes that all kwargs are `data`.
              success(foo: :bar)

              # Longer form. More explicit.
              success(data: {foo: :bar})

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
              success(data: {foo: :bar}, message: "foo")
              success(data: {foo: :bar}, code: :foo)
              success(data: {foo: :bar}, message: "foo", code: :foo)
              success(message: "foo")
              success(code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys) { command_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end

      context "when kwargs contain `:code` key" do
        context "when kwargs do NOT contain extra keys" do
          let(:kwargs) { {code: :foo} }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when kwargs contain extra keys" do
          let(:kwargs) { {code: :foo, extra_key: anything} }

          let(:exception_message) do
            <<~TEXT
              `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form. Assumes that all kwargs are `data`.
              success(foo: :bar)

              # Longer form. More explicit.
              success(data: {foo: :bar})

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
              success(data: {foo: :bar}, message: "foo")
              success(data: {foo: :bar}, code: :foo)
              success(data: {foo: :bar}, message: "foo", code: :foo)
              success(message: "foo")
              success(code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys) { command_result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
