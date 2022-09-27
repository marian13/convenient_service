# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Concerns
        module Errors
          class ConcernsAreIncluded < ConvenientService::Error
            def initialize(concerns:)
              message = <<~TEXT
                Concerns are included into `#{concerns.entity}`.

                Did you call `concerns(&configuration_block)` after using any plugin, after calling `commit_config!`?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
