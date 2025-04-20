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
              module HasResult
                module Exceptions
                  class StepHasUnknownType < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:)
                      message = <<~TEXT
                        Step `#{step.printable_action}` has unknown type.

                        Please, ensure the first `step` argument has NO typos.
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
