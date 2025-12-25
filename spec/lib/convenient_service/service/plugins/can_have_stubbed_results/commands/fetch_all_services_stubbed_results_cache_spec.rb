# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

  include ConvenientService::RSpec::Helpers::StubService

  example_group "class methods" do
    describe ".call" do
      let(:command) { described_class.new(service: service) }

      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      context "when `RSpec` current example is NOT set" do
        before do
          allow(ConvenientService::Dependencies::Queries::Gems::RSpec).to receive(:current_example).and_return(nil)
        end

        it "returns empty cache" do
          expect(command.call).to eq(ConvenientService::Support::Cache.backed_by(:thread_safe_hash).new)
        end

        specify do
          cache = ConvenientService::Support::Cache.backed_by(:thread_safe_hash).new

          expect { command.call }
            .to delegate_to(ConvenientService::Support::Cache, :backed_by)
              .with_arguments(:thread_safe_hash)
              .and_return { cache }
        end

        specify do
          expect { command.call }.not_to cache_its_value
        end
      end

      context "when `RSpec` current example is set" do
        it "returns empty cache" do
          expect(command.call).to eq(ConvenientService::Support::Cache.backed_by(:thread_safe_hash).new)
        end

        specify do
          command.call

          expect { command.call }
            .not_to delegate_to(ConvenientService::Support::Cache, :backed_by)
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
