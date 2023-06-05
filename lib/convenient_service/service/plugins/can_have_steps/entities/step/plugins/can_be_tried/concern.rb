# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeTried
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def try?
                      Utils::Bool.to_bool(internals.cache[:try])
                    end

                    ##
                    # @return [Bool]
                    #
                    def not_try?
                      !try?
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    # @note `service_try_result` has middlewares.
                    #
                    # @internal
                    #   IMPORTANT: `service.klass.try_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
                    #
                    def service_try_result
                      assert_has_organizer!

                      service.klass.try_result(**input_values)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    # @note `try_result` has middlewares.
                    #
                    # @internal
                    #   NOTE: `copy` logic is used in `result` as well.
                    #   TODO: Extract `copy` logic into separate method with a proper naming.
                    #
                    def try_result
                      service_try_result.copy(overrides: {kwargs: {step: self, service: organizer}})
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
