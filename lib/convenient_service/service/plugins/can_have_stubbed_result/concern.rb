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

              ##
              # IMPORTANT: ivar name with class and current thread enforces thread safety since there is no resource to share.
              #
              # TODO: Thread safety specs.
              #
              # NOTE: `self` is a service class in the current context. For example:
              #
              #   before do
              #     stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
              #       .with_arguments(command: node_available_command)
              #       .to return_result(node_available_status)
              #   end
              #
              #   # Then `self` is `ConvenientService::Examples::Standard::Gemfile::Services::RunShell`.
              #
              ivar_name = "@__convenient_service_stubbed_results__#{object_id}__#{Thread.current.object_id}__"

              cache = Utils::Object.instance_variable_fetch(::RSpec.current_example, ivar_name) { Support::Cache.new }

              cache.scope(self)
            end
          end
        end
      end
    end
  end
end
