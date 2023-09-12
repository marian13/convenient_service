# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallbacks
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def fallback_true_step?
                      params.extra_kwargs[:fallback] == true
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_failure_step?
                      Utils::Array.wrap(params.extra_kwargs[:fallback]).include?(:failure)
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_error_step?
                      Utils::Array.wrap(params.extra_kwargs[:fallback]).include?(:error)
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_step?
                      fallback_true_step? || fallback_failure_step? || fallback_error_step?
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    #
                    # @note `service_fallback_failure_result` has middlewares.
                    #
                    # @internal
                    #   IMPORTANT: `service.klass.fallback_failure_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
                    #
                    def service_fallback_failure_result
                      service.klass.fallback_failure_result(**input_values)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    # @note `fallback_failure_result` has middlewares.
                    #
                    def fallback_failure_result
                      convert_to_step_result(service_fallback_failure_result)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    #
                    # @note `service_fallback_error_result` has middlewares.
                    #
                    # @internal
                    #   IMPORTANT: `service.klass.fallback_error_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
                    #
                    def service_fallback_error_result
                      service.klass.fallback_error_result(**input_values)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    # @note `fallback_error_result` has middlewares.
                    #
                    def fallback_error_result
                      convert_to_step_result(service_fallback_error_result)
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
