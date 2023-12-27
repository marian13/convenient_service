# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Exceptions
              class StepHasNoOrganizer < ::ConvenientService::Exception
                def initialize_with_kwargs(step:)
                  message = <<~TEXT
                    Step `#{step.printable_service}` has not assigned organizer.

                    Did you forget to set it?
                  TEXT

                  initialize(message)
                end
              end
            end
          end
        end
      end
    end
  end
end
