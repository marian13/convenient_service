# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern::ClassMethods, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Standard::Config

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
