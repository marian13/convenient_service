# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CastJSendAttributes do
  example_group "class methods" do
    describe ".call" do
      let(:service_class) { Class.new }
      let(:service_instance) { service_class.new }

      let(:command_result) { described_class.call(attributes: attributes) }
      let(:attributes) { {service: service_instance, status: :foo, data: {foo: :bar}, message: "foo", code: :foo} }

      it "returns `struct` with `attributes[:service]` as `service`" do
        expect(command_result.service).to eq(attributes[:service])
      end

      it "returns `struct` with `attributes[:status]` casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status` as `status`" do
        expect(command_result.status).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.cast(attributes[:status]))
      end

      context "when `attributes[:status]` is NOT castable" do
        let(:command_result) { described_class.call(attributes: attributes.merge(status: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `attributes[:data]` casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data` as `data`" do
        expect(command_result.data).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.cast(attributes[:data]))
      end

      context "when `attributes[:data]` is NOT castable" do
        let(:command_result) { described_class.call(attributes: attributes.merge(data: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `attributes[:message]` casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message` as `message`" do
        expect(command_result.message).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.cast(attributes[:message]))
      end

      context "when `attributes[:message]` is NOT castable" do
        let(:command_result) { described_class.call(attributes: attributes.merge(message: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `attributes[:code]` casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code` as `code`" do
        expect(command_result.code).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.cast(attributes[:code]))
      end

      context "when `attributes[:code]` is NOT castable" do
        let(:command_result) { described_class.call(attributes: attributes.merge(code: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
