# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeServiceStep
                module Exceptions
                  class StepIsNotServiceStep < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:)
                      message = <<~TEXT
                        Step `#{step.printable_action}` is NOT a service step.
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
  end
end
