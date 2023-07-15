# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Configs::Standard

      def result
        success
      end
    end
  end

  let(:result_class) { service_class.result_class }
  let(:result_instance) { service_class.result }

  let(:code) { result_instance.unsafe_code }
  let(:data) { result_instance.unsafe_data }
  let(:message) { result_instance.unsafe_message }
  let(:status) { result_instance.status }

  example_group "class methods" do
    describe ".code" do
      let(:value) { :foo }

      specify do
        expect { result_class.code(value: value, result: result_instance) }
          .to delegate_to(result_class.code_class, :cast!)
          .with_arguments(value)
      end

      specify do
        allow(result_class.code_class).to receive(:cast!).and_return(code)

        expect { result_class.code(value: value, result: result_instance) }
          .to delegate_to(code, :copy)
          .with_arguments(overrides: {kwargs: {result: result_instance}})
          .and_return_its_value
      end

      context "when `result` is NOT passed" do
        let(:code) { result_class.code(value: value) }
        let(:not_initialized_result_instance) { double }

        before do
          allow(result_class).to receive(:new_without_initialize).and_return(not_initialized_result_instance)
        end

        it "defaults `result` to `result_class.new_without_initialize`" do
          expect(code.result).to eq(not_initialized_result_instance)
        end
      end
    end

    describe ".data" do
      let(:value) { {foo: :bar} }

      specify do
        expect { result_class.data(value: value, result: result_instance) }
          .to delegate_to(result_class.data_class, :cast!)
          .with_arguments(value)
      end

      specify do
        allow(result_class.data_class).to receive(:cast!).and_return(data)

        expect { result_class.data(value: value, result: result_instance) }
          .to delegate_to(data, :copy)
          .with_arguments(overrides: {kwargs: {result: result_instance}})
          .and_return_its_value
      end

      context "when `result` is NOT passed" do
        let(:data) { result_class.data(value: value) }
        let(:not_initialized_result_instance) { double }

        before do
          allow(result_class).to receive(:new_without_initialize).and_return(not_initialized_result_instance)
        end

        it "defaults `result` to `result_class.new_without_initialize`" do
          expect(data.result).to eq(not_initialized_result_instance)
        end
      end
    end

    describe ".message" do
      let(:value) { "foo" }

      specify do
        expect { result_class.message(value: value, result: result_instance) }
          .to delegate_to(result_class.message_class, :cast!)
          .with_arguments(value)
      end

      specify do
        allow(result_class.message_class).to receive(:cast!).and_return(message)

        expect { result_class.message(value: value, result: result_instance) }
          .to delegate_to(message, :copy)
          .with_arguments(overrides: {kwargs: {result: result_instance}})
          .and_return_its_value
      end

      context "when `result` is NOT passed" do
        let(:message) { result_class.message(value: value) }
        let(:not_initialized_result_instance) { double }

        before do
          allow(result_class).to receive(:new_without_initialize).and_return(not_initialized_result_instance)
        end

        it "defaults `result` to `result_class.new_without_initialize`" do
          expect(message.result).to eq(not_initialized_result_instance)
        end
      end
    end

    describe ".status" do
      let(:value) { :foo }

      specify do
        expect { result_class.status(value: value, result: result_instance) }
          .to delegate_to(result_class.status_class, :cast!)
          .with_arguments(value)
      end

      specify do
        allow(result_class.status_class).to receive(:cast!).and_return(status)

        expect { result_class.status(value: value, result: result_instance) }
          .to delegate_to(status, :copy)
          .with_arguments(overrides: {kwargs: {result: result_instance}})
          .and_return_its_value
      end

      context "when `result` is NOT passed" do
        let(:status) { result_class.status(value: value) }
        let(:not_initialized_result_instance) { double }

        before do
          allow(result_class).to receive(:new_without_initialize).and_return(not_initialized_result_instance)
        end

        it "defaults `result` to `result_class.new_without_initialize`" do
          expect(status.result).to eq(not_initialized_result_instance)
        end
      end
    end

    describe ".code_class" do
      specify do
        expect { result_class.code_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CreateCodeClass, :call)
          .with_arguments(result_class: result_class)
          .and_return_its_value
      end

      specify do
        expect { result_class.code_class }.to cache_its_value
      end
    end

    describe ".data_class" do
      specify do
        expect { result_class.data_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CreateDataClass, :call)
          .with_arguments(result_class: result_class)
          .and_return_its_value
      end

      specify do
        expect { result_class.data_class }.to cache_its_value
      end
    end

    describe ".message_class" do
      specify do
        expect { result_class.message_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CreateMessageClass, :call)
          .with_arguments(result_class: result_class)
          .and_return_its_value
      end

      specify do
        expect { result_class.message_class }.to cache_its_value
      end
    end

    describe ".status_class" do
      specify do
        expect { result_class.status_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CreateStatusClass, :call)
          .with_arguments(result_class: result_class)
          .and_return_its_value
      end

      specify do
        expect { result_class.status_class }.to cache_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
