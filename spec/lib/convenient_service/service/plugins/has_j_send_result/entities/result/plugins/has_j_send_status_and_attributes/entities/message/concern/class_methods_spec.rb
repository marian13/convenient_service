# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other.to_s) }

        it "returns that symbol casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other) }

        it "returns that string casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is message" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: "foo") }
        let(:message) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(message)
        end
      end
    end

    describe ".===" do
      let(:message_class) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message }

      let(:other) { 42 }

      specify do
        expect { message_class === other }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Commands::IsMessage, :call)
          .with_arguments(message: other)
      end

      it "returns `false`" do
        expect(message_class === other).to eq(false)
      end

      context "when `other` is message instance in terms of `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Commands::IsMessage`" do
        let(:service) do
          Class.new do
            include ConvenientService::Service::Configs::Essential
            include ConvenientService::Service::Configs::Inspect

            def result
              success
            end
          end
        end

        let(:other) { service.result.message }

        specify do
          expect { message_class === other }
            .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Commands::IsMessage, :call)
            .with_arguments(message: other)
        end

        it "returns `true`" do
          expect(message_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message` instance" do
        let(:other) { ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.cast("foo") }

        it "returns `true`" do
          expect(message_class === other).to eq(true)
        end
      end

      context "when `other` is `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message` descendant instance" do
        let(:descendant_class) { Class.new(message_class) }

        let(:other) { descendant_class.cast("foo") }

        it "returns `true`" do
          expect(message_class === other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
