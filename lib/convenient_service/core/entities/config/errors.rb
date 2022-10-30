# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Errors
          class ConfigIsCommitted < ConvenientService::Error
            def initialize(config:)
              message = <<~TEXT
                Config for `#{config.klass}` is already committed. Only uncommitted configs can be modified.

                Did you accidentally call `concerns(&configuration_block)` or `middlewares(method, scope: scope, &configuration_block)` after using any plugin, after calling `commit_config!`?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
