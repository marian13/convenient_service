# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Constants
        SCOPES = [
          INSTANCE_SCOPE = :instance,
          CLASS_SCOPE = :class
        ]

        DEFAULT_SCOPE = Constants::INSTANCE_SCOPE
        DEFAULT_PREPEND = false
        DEFAULT_ALIAS_SLUG = ""
      end
    end
  end
end
