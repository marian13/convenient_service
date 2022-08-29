# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Commands::CastResultParams do
  example_group "class methods" do
    describe ".call" do
      let(:service_class) { Class.new }
      let(:service_instance) { service_class.new }

      let(:command_result) { described_class.call(params: params) }
      let(:params) { {service: service_instance, status: :foo, data: {foo: :bar}, message: "foo", code: :foo} }

      it "returns `struct' with `params[:service]' as `service'" do
        expect(command_result.service).to eq(params[:service])
      end

      it "returns `struct' with `params[:status]' casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Status' as `status'" do
        expect(command_result.status).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Status.cast(params[:status]))
      end

      context "when `params[:status]' is NOT castable" do
        let(:command_result) { described_class.call(params: params.merge(status: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42' into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Status}'.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct' with `params[:data]' casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data' as `data'" do
        expect(command_result.data).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.cast(params[:data]))
      end

      context "when `params[:data]' is NOT castable" do
        let(:command_result) { described_class.call(params: params.merge(data: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42' into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data}'.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct' with `params[:message]' casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Message' as `message'" do
        expect(command_result.message).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Message.cast(params[:message]))
      end

      context "when `params[:message]' is NOT castable" do
        let(:command_result) { described_class.call(params: params.merge(message: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42' into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Message}'.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct' with `params[:code]' casted to `ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code' as `code'" do
        expect(command_result.code).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.cast(params[:code]))
      end

      context "when `params[:code]' is NOT castable" do
        let(:command_result) { described_class.call(params: params.merge(code: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42' into `#{ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code}'.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast'" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
