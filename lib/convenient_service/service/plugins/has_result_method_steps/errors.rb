# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Errors
          class MethodForStepIsNotDefined < ConvenientService::Error
            def initialize(service_class:, method_name:)
              message = <<~TEXT
                Service #{service_class} tries to use `#{method_name}' method in a step, but it NOT defined.

                Did you forget to define it?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
