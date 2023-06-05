# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CastJSendAttributes do
  example_group "class methods" do
    describe ".call" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Minimal

          def result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }
      let(:result) { service_instance.result }

      let(:command_result) { described_class.call(result: result, kwargs: kwargs) }
      let(:kwargs) { {service: service_instance, status: :foo, data: {foo: :bar}, message: "foo", code: :foo} }

      it "returns `struct` with `kwargs[:service]` as `service`" do
        expect(command_result.service).to eq(kwargs[:service])
      end

      it "returns `struct` with `kwargs[:status]` casted to `result.class.status_class` as `status`" do
        expect(command_result.status).to eq(service_class.result_class.status(value: kwargs[:status], result: result))
      end

      context "when `kwargs[:status]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(status: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.status_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `kwargs[:data]` casted to `result.class.data_class` as `data`" do
        expect(command_result.data).to eq(service_class.result_class.data(value: kwargs[:data], result: result))
      end

      context "when `kwargs[:data]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(data: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.data_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `kwargs[:message]` casted to `result.class.message_class` as `message`" do
        expect(command_result.message).to eq(service_class.result_class.message(value: kwargs[:message], result: result))
      end

      context "when `kwargs[:message]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(message: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.message_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Errors::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Errors::FailedToCast)
            .with_message(error_message)
        end
      end

      it "returns `struct` with `kwargs[:code]` casted to `result.class.code_class` as `code`" do
        expect(command_result.code).to eq(service_class.result_class.code(value: kwargs[:code], result: result))
      end

      context "when `kwargs[:code]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(code: 42)) }

        let(:error_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.code_class}`.
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
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers