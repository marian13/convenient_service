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
              module CanHaveParentResult
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                  #
                  # @internal
                  #   IMPORTANT: `CanHaveParentResult` middleware MUST be placed after `HasResult` middleware.
                  #
                  #   NOTE: `result` at the moment of this middleware is still a `service_result` (or `method_result`). It is only later converted to `step_result` by `HasResult` middleware.
                  #   That is why `result` is used as `parent` here.
                  #
                  def next(...)
                    result = chain.next(...)

                    result.copy(overrides: {kwargs: {parent: result}})
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
