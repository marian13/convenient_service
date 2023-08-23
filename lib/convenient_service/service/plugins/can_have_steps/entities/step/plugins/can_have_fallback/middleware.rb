# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallback
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  #
                  def next(...)
                    result = chain.next(...)

                    return result unless entity.fallback_step?

                    return result if result.success?(mark_status_as_checked: false)

                    entity.fallback_result(...)
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
