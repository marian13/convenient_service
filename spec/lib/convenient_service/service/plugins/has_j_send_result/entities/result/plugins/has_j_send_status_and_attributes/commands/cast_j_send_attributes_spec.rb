# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CastJSendAttributes, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:service_instance) { service_class.new }
      let(:result) { service_instance.result }

      let(:command_result) { described_class.call(result: result, kwargs: kwargs) }
      let(:kwargs) { {service: service_instance, status: :foo, data: {foo: :bar}, message: "foo", code: :foo, **extra_kwargs} }
      let(:extra_kwargs) { {} }

      it "returns `struct` with `kwargs[:service]` as `service`" do
        expect(command_result.service).to eq(kwargs[:service])
      end

      it "returns `struct` with `kwargs[:status]` casted to `result.class.status_class` as `status`" do
        expect(command_result.status).to eq(result.create_status!(kwargs[:status]))
      end

      context "when `kwargs[:status]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(status: 42)) }

        let(:exception_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.status_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
            .with_message(exception_message)
        end
      end

      it "returns `struct` with `kwargs[:data]` casted to `result.class.data_class` as `data`" do
        expect(command_result.data).to eq(result.create_data!(kwargs[:data]))
      end

      context "when `kwargs[:data]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(data: 42)) }

        let(:exception_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.data_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
            .with_message(exception_message)
        end
      end

      it "returns `struct` with `kwargs[:message]` casted to `result.class.message_class` as `message`" do
        expect(command_result.message).to eq(result.create_message!(kwargs[:message]))
      end

      context "when `kwargs[:message]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(message: 42)) }

        let(:exception_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.message_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
            .with_message(exception_message)
        end
      end

      it "returns `struct` with `kwargs[:code]` casted to `result.class.code_class` as `code`" do
        expect(command_result.code).to eq(result.create_code!(kwargs[:code]))
      end

      context "when `kwargs[:code]` is NOT castable" do
        let(:command_result) { described_class.call(result: result, kwargs: kwargs.merge(code: 42)) }

        let(:exception_message) do
          <<~TEXT
            Failed to cast `42` into `#{result.class.code_class}`.
          TEXT
        end

        it "raises `ConvenientService::Support::Castable::Exceptions::FailedToCast`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::Castable::Exceptions::FailedToCast)
            .with_message(exception_message)
        end
      end

      context "when `kwargs` have extra kwargs" do
        let(:extra_kwargs) { {parent: nil} }

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Utils::Hash, :except)
            .with_arguments(kwargs, [:service, :status, :data, :message, :code])
        end

        it "returns `kwargs` without `[:service, :status, :data, :message, :code]` keys as `extra_kwargs`" do
          expect(command_result.extra_kwargs).to eq({parent: nil})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
