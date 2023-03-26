# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern::ClassMethods do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) do
    Class.new do
      include ConvenientService::Configs::Standard
    end
  end

  let(:result_class) { service_class.result_class }

  example_group "class methods" do
    describe ".code_class" do
      specify do
        expect { result_class.code_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Commands::CreateCodeClass, :call)
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
          .to delegate_to(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Commands::CreateDataClass, :call)
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
          .to delegate_to(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Commands::CreateMessageClass, :call)
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
          .to delegate_to(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Commands::CreateStatusClass, :call)
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
