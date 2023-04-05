# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
        module Concern
          include Support::Concern

          included do |service_class|
            service_class.extend ClassMethods

            ##
            # IMPORTANT:
            #   - Initializes `stubbed_results` during the `include Concern` process.
            #   - Tries to enforce thread-safety in such a way.
            #   - https://github.com/ruby/spec/blob/master/core/module/include_spec.rb
            #   - https://github.com/ruby/ruby/blob/master/class.c
            #
            service_class.stubbed_results
          end

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
            def stubbed_results
              ##
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
              cache =
                if Support::Gems::RSpec.current_example
                  Utils::Object.instance_variable_fetch(Support::Gems::RSpec.current_example, :@__convenient_service_stubbed_results__) { Support::Cache.create }
                else
                  Support::Cache.create
                end

              cache.scope(self)
            end
          end
        end
      end
    end
  end
end
