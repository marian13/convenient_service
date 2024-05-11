# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Essential

      def result
        success
      end
    end
  end

  let(:service_instance) { service_class.new }
  let(:not_initialized_service_instance) { service_class.new_without_initialize }

  let(:params) { {service: service_instance, data: data, message: message, code: code} }
  let(:data) { {foo: "bar"} }
  let(:message) { "foo" }
  let(:code) { :custom }

  let(:constants) { ConvenientService::Service::Plugins::HasJSendResult::Constants }

  example_group "class methods" do
    describe "#success" do
      let(:result) { service_class.success(**params) }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(**params.merge(service: service_instance, status: constants::SUCCESS_STATUS))
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:service])) }

        before do
          allow(service_class).to receive(:new_without_initialize).and_return(not_initialized_service_instance)
        end

        it "defaults `service` to `service_class.new_without_initialize`" do
          expect(result.service).to eq(not_initialized_service_instance)
        end
      end

      context "when `data` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:data])) }

        before do
          result.success?
        end

        it "defaults `data` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAUTL_SUCCESS_DATA`" do
          expect(result.data).to eq(result.create_data(constants::DEFAULT_SUCCESS_DATA))
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:message])) }

        before do
          result.success?
        end

        it "defaults `message` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_SUCCESS_MESSAGE`" do
          expect(result.message).to eq(result.create_message(constants::DEFAULT_SUCCESS_MESSAGE))
        end
      end

      context "when `code` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:code])) }

        before do
          result.success?
        end

        it "defaults `code` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_SUCCESS_CODE`" do
          expect(result.code).to eq(result.create_code(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_SUCCESS_CODE))
        end
      end
    end

    describe "#failure" do
      let(:result) { service_class.failure(**params) }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(**params.merge(service: service_instance, status: constants::FAILURE_STATUS))
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:service])) }

        before do
          allow(service_class).to receive(:new_without_initialize).and_return(not_initialized_service_instance)
        end

        it "defaults `service` to `service_class.new_without_initialize`" do
          expect(result.service).to eq(not_initialized_service_instance)
        end
      end

      context "when `data` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:data])) }

        before do
          result.failure?
        end

        it "defaults `data` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAUTL_FAILURE_DATA`" do
          expect(result.data).to eq(result.create_data(constants::DEFAULT_FAILURE_DATA))
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:message])) }

        before do
          result.failure?
        end

        it "defaults `message` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_MESSAGE`" do
          expect(result.message).to eq(result.create_message(constants::DEFAULT_FAILURE_MESSAGE))
        end
      end

      context "when `code` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:code])) }

        before do
          result.failure?
        end

        it "defaults `code` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_CODE`" do
          expect(result.code).to eq(result.create_code(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_CODE))
        end
      end
    end

    describe "#error" do
      let(:result) { service_class.error(**params) }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(**params.merge(service: service_instance, status: constants::ERROR_STATUS))
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:service])) }

        before do
          allow(service_class).to receive(:new_without_initialize).and_return(not_initialized_service_instance)
        end

        it "defaults `service` to `service_class.new_without_initialize`" do
          expect(result.service).to eq(not_initialized_service_instance)
        end
      end

      context "when `data` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:data])) }

        before do
          result.error?
        end

        it "defaults `data` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAUTL_ERROR_DATA`" do
          expect(result.data).to eq(result.create_data(constants::DEFAULT_ERROR_DATA))
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:message])) }

        before do
          result.error?
        end

        it "defaults `message` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_MESSAGE`" do
          expect(result.message).to eq(result.create_message(constants::DEFAULT_ERROR_MESSAGE))
        end
      end

      context "when `code` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:code])) }

        before do
          result.error?
        end

        it "defaults `code` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_CODE`" do
          expect(result.code).to eq(result.create_code(ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_CODE))
        end
      end
    end

    describe ".result_class" do
      specify do
        expect { service_class.result_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Commands::CreateResultClass, :call)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      end

      specify do
        expect { service_class.result_class }.to cache_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
