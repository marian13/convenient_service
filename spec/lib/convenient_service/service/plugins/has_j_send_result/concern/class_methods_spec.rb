# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Concern::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Configs::Minimal

      def result
        success
      end
    end
  end

  let(:service_instance) { service_class.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  let(:constants) { ConvenientService::Service::Plugins::HasJSendResult::Constants }

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#success" do
      let(:result) { service_class.success(**params) }
      let(:params) { {service: service_instance, data: data} }
      let(:data) { {foo: :bar} }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(service: service_instance, status: constants::SUCCESS_STATUS, data: data, message: constants::SUCCESS_MESSAGE, code: constants::SUCCESS_CODE)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.success(**ConvenientService::Utils::Hash.except(params, [:service])) }
        let(:not_initialized_service_instance) { double }

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
          expect(result.data).to eq(service_class.result_class.data(value: constants::DEFAULT_SUCCESS_DATA))
        end
      end
    end

    describe "#failure" do
      let(:result) { service_class.failure(**params) }
      let(:params) { {service: service_instance, data: data, message: message} }
      let(:data) { {foo: "bar"} }
      let(:message) { "foo" }
      let(:first_pair_message) { data.first.join(" ") }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(service: service_instance, status: constants::FAILURE_STATUS, data: data, message: message, code: constants::FAILURE_CODE)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:service])) }
        let(:not_initialized_service_instance) { double }

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
          result.success?
        end

        it "defaults `data` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_DATA`" do
          expect(result.data).to eq(service_class.result_class.data(value: constants::DEFAULT_FAILURE_DATA))
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:message])) }

        context "when `data` is NOT empty" do
          before do
            result.success?
          end

          it "defaults `message` to concatenated by space first key and first value from `data`" do
            expect(result.message).to eq(service_class.result_class.message(value: first_pair_message))
          end
        end

        context "when `data` is empty" do
          let(:result) { service_class.failure(**ConvenientService::Utils::Hash.except(params, [:message]).merge(data: {})) }

          it "internally passes `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_FAILURE_MESSAGE` as `message` to result constructor" do
            expect { result }
              .to delegate_to(service_class.result_class, :new)
              .with_arguments(service: service_instance, status: constants::FAILURE_STATUS, data: {}, message: constants::DEFAULT_FAILURE_MESSAGE, code: constants::FAILURE_CODE)
          end
        end
      end
    end

    describe "#error" do
      let(:result) { service_class.error(**params) }
      let(:params) { {service: service_instance, message: message, code: code} }
      let(:message) { "foo" }
      let(:code) { :custom }

      specify do
        expect { result }
          .to delegate_to(service_class.result_class, :new)
          .with_arguments(service: service_instance, status: constants::ERROR_STATUS, data: constants::ERROR_DATA, message: message, code: code)
      end

      context "when `service` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:service])) }
        let(:not_initialized_service_instance) { double }

        before do
          allow(service_class).to receive(:new_without_initialize).and_return(not_initialized_service_instance)
        end

        it "defaults `service` to `service_class.new_without_initialize`" do
          expect(result.service).to eq(not_initialized_service_instance)
        end
      end

      context "when `message` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:message])) }

        before do
          result.success?
        end

        it "defaults `message` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_MESSAGE`" do
          expect(result.message).to eq(service_class.result_class.message(value: constants::DEFAULT_ERROR_MESSAGE))
        end
      end

      context "when `code` is NOT passed" do
        let(:result) { service_class.error(**ConvenientService::Utils::Hash.except(params, [:code])) }

        before do
          result.success?
        end

        it "defaults `code` to `ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_CODE`" do
          expect(result.code).to eq(service_class.result_class.code(value: ConvenientService::Service::Plugins::HasJSendResult::Constants::DEFAULT_ERROR_CODE))
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
