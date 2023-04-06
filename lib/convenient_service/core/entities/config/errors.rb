# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Errors
          class ConfigIsCommitted < ::ConvenientService::Error
            ##
            # @param config [ConvenientService::Core::Entities::Config]
            # @return [void]
            #
            def initialize(config:)
              message = <<~TEXT
                Config for `#{config.klass}` is already committed. Only uncommitted configs can be modified.

                Did you accidentally call `concerns(&configuration_block)` or `middlewares(method, scope: scope, &configuration_block)` after using any plugin, after calling `commit_config!`?
              TEXT

              super(message)
            end
          end

          class TooManyCommitsFromMethodMissing < ::ConvenientService::Error
            ##
            # @param config [ConvenientService::Core::Entities::Config]
            # @return [void]
            #
            # @internal
            #   TODO: Create a troubleshooting page with possible reasons (preliminary RSpec mocks etc).
            #   Append a link to it to the error message.
            #
            def initialize(config:)
              message = <<~TEXT
                `#{config.klass}` config is committed too many times from `method_missing`.

                In order to resolve this issue try to commit it manually before usage of any config-dependent method.

                Example 1 (outside class):

                  # Commitment:
                  #{config.klass}.commit_config!

                  # Few lines later - usage:
                  #{config.klass}.result # or whatever method.

                Example 2 (inside class):

                  class #{config.klass}
                    # ...
                    commit_config!

                    step :result # or any other method that becomes available after config commitment.
                  end
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
