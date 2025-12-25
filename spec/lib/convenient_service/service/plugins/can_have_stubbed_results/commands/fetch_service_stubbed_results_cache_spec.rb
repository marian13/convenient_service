# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchServiceStubbedResultsCache, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::CacheItsValue

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

      let(:cache) { ConvenientService::Support::Cache.backed_by(:thread_safe_hash).new }

      specify do
        expect { command.call(service: service) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache, :call)
          .with_arguments(service: service)
      end

      specify do
        allow(ConvenientService::Service::Plugins::CanHaveStubbedResults::Commands::FetchAllServicesStubbedResultsCache).to receive(:call).and_return(cache)

        expect { command.call(service: service) }
          .to delegate_to(cache, :scope)
          .with_arguments(service, backed_by: :thread_safe_array)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
