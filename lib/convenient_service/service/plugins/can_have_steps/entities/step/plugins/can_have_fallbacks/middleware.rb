# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallbacks
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
                      fallback_failure_step? ? entity.fallback_failure_result(...) : result
                    when :error
                      fallback_error_step? ? entity.fallback_error_result(...) : result
                    end
                  end

                  private

                  ##
                  # @return [Boolean]
                  #
                  def fallback_failure_step?
                    entity.fallback_failure_step? || fallback_true_step_as_failure_step?
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_true_step_as_failure_step?
                    entity.fallback_true_step? && fallback_true_status == :failure
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_error_step?
                    entity.fallback_error_step? || fallback_true_step_as_error_step?
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_true_step_as_error_step?
                    entity.fallback_true_step? && fallback_true_status == :error
                  end

                  ##
                  # @return [Symbol]
                  #
                  def fallback_true_status
                    middleware_arguments.kwargs.fetch(:fallback_true_status) { :failure }
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
