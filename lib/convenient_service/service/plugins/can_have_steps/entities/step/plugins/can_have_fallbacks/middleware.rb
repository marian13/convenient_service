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
                      fallback_failure_step? ? fallback_failure_result(result) : result
                    else # :error
                      fallback_error_step? ? fallback_error_result(result) : result
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
                  # @internal
                  #   IMPORTANT: `fallback` MUST NOT create new service instance, otherwise memoized instance variables will NOT be reused.
                  #
                  def fallback_failure_result(result)
                    refute_method_step! || result.with_failure_fallback(raise_when_missing: false) || ::ConvenientService.raise(Exceptions::FallbackResultIsNotOverridden.new(step: step, service: result.service, status: :failure))
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden, ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback]
                  #
                  # @internal
                  #   IMPORTANT: `fallback` MUST NOT create new service instance, otherwise memoized instance variables will NOT be reused.
                  #
                  def fallback_error_result(result)
                    refute_method_step! || result.with_error_fallback(raise_when_missing: false) || ::ConvenientService.raise(Exceptions::FallbackResultIsNotOverridden.new(step: step, service: result.service, status: :error))
                  end

                  ##
                  # @return [void]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Exceptions::MethodStepCanNotHaveFallback]
                  #
                  # @internal
                  #   TODO: Consider to move this assertion to the build time.
                  #
                  def refute_method_step!
                    ::ConvenientService.raise Exceptions::MethodStepCanNotHaveFallback.new(step: step) if step.method_step?
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
