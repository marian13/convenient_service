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
              module CanBeEvaluated
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                  #
                  alias_method :step, :entity

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotMethodStep, ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::MethodForStepIsNotDefined]
                  #
                  def next(...)
                    result = chain.next(...)

                    step.mark_as_evaluated!

                    result
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
