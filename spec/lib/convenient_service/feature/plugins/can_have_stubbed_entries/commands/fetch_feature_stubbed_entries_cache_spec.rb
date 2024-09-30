# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchFeatureStubbedEntriesCache, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      let(:feature) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          def result
            success
          end
        end
      end

      let(:cache) { ConvenientService::Support::Cache.create(backend: :thread_safe_array) }

      specify do
        expect { command.call(feature: feature) }
          .to delegate_to(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchAllFeaturesStubbedEntriesCache, :call)
          .without_arguments
      end

      specify do
        allow(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Commands::FetchAllFeaturesStubbedEntriesCache).to receive(:call).and_return(cache)

        expect { command.call(feature: feature) }
          .to delegate_to(cache, :scope)
          .with_arguments(feature)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
