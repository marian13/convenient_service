# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Commands
          class FetchAllServicesStubbedResultsCache < Support::Command
            ##
            # @return [ConvenientService::Support::Cache]
            #
            # @internal
            #   NOTE: `::RSpec.current_example` docs.
            #   - https://www.rubydoc.info/github/rspec/rspec-core/RSpec.current_example
            #   - https://github.com/rspec/rspec-core/blob/v3.12.0/lib/rspec/core.rb#L122
            #   - https://github.com/rspec/rspec-support/blob/v3.12.0/lib/rspec/support.rb#L92
            #   - https://relishapp.com/rspec/rspec-core/docs/metadata/current-example
            #
            def call
              if Dependencies.rspec.current_example
                Utils::Object.memoize_including_falsy_values(Dependencies.rspec.current_example, :@__convenient_service_stubbed_results__) { Support::Cache.backed_by(:thread_safe_hash).new }
              else
                Support::Cache.backed_by(:thread_safe_hash).new
              end
            end
          end
        end
      end
    end
  end
end
