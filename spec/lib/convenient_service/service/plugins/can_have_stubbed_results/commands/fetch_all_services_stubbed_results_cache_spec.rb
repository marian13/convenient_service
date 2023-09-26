# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class }

      context "when `RSpec` current example is NOT set" do
        before do
          allow(ConvenientService::Support::Gems::RSpec).to receive(:current_example).and_return(nil)
        end

        it "returns empty cache" do
          expect(command.call).to eq(ConvenientService::Support::Cache.create(backend: :thread_safe_array))
        end

        specify do
          expect { command.call }
            .to delegate_to(ConvenientService::Support::Cache, :create)
            .with_arguments(backend: :thread_safe_array)
            .and_return_its_value
        end

        specify do
          expect { command.call }.not_to cache_its_value
        end
      end

      context "when `RSpec` current example is set" do
        it "returns empty cache" do
          expect(command.call).to eq(ConvenientService::Support::Cache.create(backend: :thread_safe_array))
        end

        specify do
          command.call

          expect { command.call }
            .not_to delegate_to(ConvenientService::Support::Cache, :create)
            .with_any_arguments
        end

        specify do
          expect { command.call }.to cache_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
