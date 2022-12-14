# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Errors
          class StepHasNoOrganizer < ConvenientService::Error
            def initialize(step:)
              message = <<~TEXT
                Step `#{step.service}` has not assigned organizer.

                Did you forget to set it?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
