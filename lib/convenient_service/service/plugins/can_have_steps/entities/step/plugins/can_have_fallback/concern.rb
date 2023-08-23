# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallback
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def fallback_step?
                      Utils.to_bool(params.extra_kwargs[:fallback])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    #
                    # @note `service_fallback_result` has middlewares.
                    #
                    # @internal
                    #   IMPORTANT: `service.klass.fallback_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
                    #
                    def service_fallback_result
                      service.klass.fallback_result(**input_values)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                    # @note `fallback_result` has middlewares.
                    #
                    def fallback_result
                      convert_to_step_result(service_fallback_result)
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
