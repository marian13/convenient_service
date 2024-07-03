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
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                  #
                  alias_method :step, :entity

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
                    step.fallback_failure_step? || fallback_true_step_as_failure_step?
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_true_step_as_failure_step?
                    step.fallback_true_step? && fallback_true_status == :failure
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_error_step?
                    step.fallback_error_step? || fallback_true_step_as_error_step?
                  end

                  ##
                  # @return [Boolean]
                  #
                  def fallback_true_step_as_error_step?
                    step.fallback_true_step? && fallback_true_status == :error
                  end

                  ##
                  # @return [Symbol]
                  #
                  def fallback_true_status
                    middleware_arguments.kwargs.fetch(:fallback_true_status) { :failure }
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden, ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback]
                  #
                  def fallback_failure_result
                    refute_method_step!

                    fallback_failure_result_own_method&.call || fallback_result_own_method&.call || ::ConvenientService.raise(Exceptions::FallbackResultIsNotOverridden.new(step: step, service: service, status: :failure))
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden, ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback]
                  #
                  def fallback_error_result
                    refute_method_step!

                    fallback_error_result_own_method&.call || fallback_result_own_method&.call || ::ConvenientService.raise(Exceptions::FallbackResultIsNotOverridden.new(step: step, service: service, status: :error))
                  end

                  ##
                  # @return [Method, nil]
                  #
                  def fallback_failure_result_own_method
                    Utils::Object.own_method(service, :fallback_failure_result, private: true)
                  end

                  ##
                  # @return [Method, nil]
                  #
                  def fallback_error_result_own_method
                    Utils::Object.own_method(service, :fallback_error_result, private: true)
                  end

                  ##
                  # @return [Method, nil]
                  #
                  def fallback_result_own_method
                    Utils::Object.own_method(service, :fallback_result, private: true)
                  end

                  ##
                  # @return [ConvenientService::Service]
                  #
                  # @internal
                  #   IMPORTANT: `step.service_class.new(**input_values)` is the reason, why services should have only kwargs as arguments.
                  #
                  def service
                    @service ||= step.service_class.new(**step.input_values)
                  end

                  ##
                  # @return [void]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback]
                  #
                  # @internal
                  #   TODO: Consider to move this assertion to the build time.
                  #
                  def refute_method_step!
                    return unless step.method_step?

                    ::ConvenientService.raise Exceptions::MethodStepCanNotHaveFallback.new(step: step)
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
