# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [ConvenientService::Support::Cache]
            #
            # @internal
            #   `::RSpec.current_example` docs:
            #   - https://www.rubydoc.info/github/rspec/rspec-core/RSpec.current_example
            #   - https://github.com/rspec/rspec-core/blob/v3.12.0/lib/rspec/core.rb#L122
            #   - https://relishapp.com/rspec/rspec-core/docs/metadata/current-example
            #
            #   TODO: Mutex for thread-safety when parallel steps will be supported.
            #
            def stubbed_results
              return Support::Cache.new unless Support::Gems::RSpec.current_example

              cache = Utils::Object.instance_variable_fetch(::RSpec.current_example, :@__convenient_service_stubbed_results__) { Support::Cache.new }

              cache.scope(self)
            end
          end
        end
      end
    end
  end
end
