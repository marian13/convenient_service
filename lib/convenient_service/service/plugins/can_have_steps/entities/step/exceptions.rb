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

              class StepResultDataNotExistingAttribute < ::ConvenientService::Exception
                ##
                # @param key [Symbol]
                # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                # @return [void]
                #
                def initialize_with_kwargs(key:, step:)
                  message = <<~TEXT
                    Step `#{step.printable_service}` result does NOT return `:#{key}` data attribute.

                    Maybe there is a typo in `out` definition?

                    Or `success` of `#{step.printable_service}` accepts a wrong key?
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
