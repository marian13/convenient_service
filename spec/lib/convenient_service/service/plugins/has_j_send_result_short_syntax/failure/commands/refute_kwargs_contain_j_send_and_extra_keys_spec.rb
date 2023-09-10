# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Commands::RefuteKwargsContainJSendAndExtraKeys do
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
              `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form with one arg. Assumes that arg is `message`.
              failure("foo")

              # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
              failure("foo", :foo)

              # Shorter form with kwargs. Assumes that all kwargs are `data`.
              failure(foo: :bar)

              # Longer form. More explicit `message`.
              failure(message: "foo")

              # Longer form. More explicit `code`.
              failure(code: :foo)

              # Longer form. More explicit `message` and `code` together.
              failure(message: "foo", code: :foo)

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
              failure(data: {foo: :bar}, message: "foo")
              failure(data: {foo: :bar}, code: :foo)
              failure(data: {foo: :bar}, message: "foo", code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
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
              `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form with one arg. Assumes that arg is `message`.
              failure("foo")

              # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
              failure("foo", :foo)

              # Shorter form with kwargs. Assumes that all kwargs are `data`.
              failure(foo: :bar)

              # Longer form. More explicit `message`.
              failure(message: "foo")

              # Longer form. More explicit `code`.
              failure(code: :foo)

              # Longer form. More explicit `message` and `code` together.
              failure(message: "foo", code: :foo)

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
              failure(data: {foo: :bar}, message: "foo")
              failure(data: {foo: :bar}, code: :foo)
              failure(data: {foo: :bar}, message: "foo", code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
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
              `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

              Please, consider something like:

              # Shorter form with one arg. Assumes that arg is `message`.
              failure("foo")

              # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
              failure("foo", :foo)

              # Shorter form with kwargs. Assumes that all kwargs are `data`.
              failure(foo: :bar)

              # Longer form. More explicit `message`.
              failure(message: "foo")

              # Longer form. More explicit `code`.
              failure(code: :foo)

              # Longer form. More explicit `message` and `code` together.
              failure(message: "foo", code: :foo)

              # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
              failure(data: {foo: :bar}, message: "foo")
              failure(data: {foo: :bar}, code: :foo)
              failure(data: {foo: :bar}, message: "foo", code: :foo)
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys`" do
            expect { command_result }
              .to raise_error(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions::KwargsContainJSendAndExtraKeys)
              .with_message(exception_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
