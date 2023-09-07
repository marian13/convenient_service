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

                    case result.status.to_sym
                    when :success
                      result
                    when :failure
                      entity.fallback_failure_step? ? entity.fallback_failure_result(...) : result
                    when :error
                      entity.fallback_error_step? ? entity.fallback_error_result(...) : result
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
