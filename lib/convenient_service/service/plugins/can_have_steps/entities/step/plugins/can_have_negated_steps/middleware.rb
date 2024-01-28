# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveNegatedSteps
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  #
                  # @internal
                  #   TODO: Write a tutorial on why decorator middleware should be preferred over proxy middleware.
                  #
                  def next(...)
                    result = chain.next(...)

                    entity.negated_step? ? result.negated_result : result
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
