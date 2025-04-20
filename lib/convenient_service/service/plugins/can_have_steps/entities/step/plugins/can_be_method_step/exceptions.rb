# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module Exceptions
                  class StepIsNotMethodStep < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:)
                      message = <<~TEXT
                        Step `#{step.printable_action}` is NOT a method step.
                      TEXT

                      initialize(message)
                    end
                  end

                  class MethodForStepIsNotDefined < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:)
                      message = <<~TEXT
                        Service `#{step.organizer.class}` tries to use `:#{step.method}` method in a step, but it is NOT defined.

                        Did you forget to define it?
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
