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
                      fallback_failure_step? ? fallback_failure_result(...) : result
                    when :error
                      fallback_error_step? ? fallback_error_result(...) : result
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

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                  #
                  # @internal
                  #   IMPORTANT: `service.klass.fallback_failure_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                  #   TODO: `entity.service.fallback_failure_result`.
                  #
                  def fallback_failure_result
                    entity.service.klass.fallback_failure_result(**entity.input_values)
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                  #
                  # @internal
                  #   IMPORTANT: `service.klass.fallback_error_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                  #   TODO: `entity.service.fallback_error_result`.
                  #
                  def fallback_error_result
                    entity.service.klass.fallback_error_result(**entity.input_values)
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
