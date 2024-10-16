# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:cache) { ConvenientService::Support::Cache.backed_by(:thread_safe_array).new }

      specify do
        expect { command.call(service: service) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache, :call)
          .without_arguments
      end

      specify do
        allow(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache).to receive(:call).and_return(cache)

        expect { command.call(service: service) }
          .to delegate_to(cache, :scope)
          .with_arguments(service)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
