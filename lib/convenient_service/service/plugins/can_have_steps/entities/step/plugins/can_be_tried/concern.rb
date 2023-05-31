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
                    #
                    def original_try_result
                      @original_try_result ||= calculate_original_try_result
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    def try_result
                      @try_result ||= calculate_try_result
                    end

                    private

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    # @internal
                    #   IMPORTANT: `service.try_result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
                    #
                    def calculate_original_try_result
                      assert_has_organizer!

                      service.klass.try_result(**input_values)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    # @internal
                    #   NOTE: `copy` logic is used in `calculate_result` as well.
                    #   TODO: Extract `copy` logic into separate method with a proper naming.
                    #
                    def calculate_try_result
                      original_try_result.copy(overrides: {kwargs: {step: self, service: organizer}})
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
