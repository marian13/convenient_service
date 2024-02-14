# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Exceptions
          class EmptyExpressionHasNoResult < ::ConvenientService::Exception
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO result.
              TEXT

              initialize(message)
            end
          end

          class EmptyExpressionHasNoStatus < ::ConvenientService::Exception
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO status.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
