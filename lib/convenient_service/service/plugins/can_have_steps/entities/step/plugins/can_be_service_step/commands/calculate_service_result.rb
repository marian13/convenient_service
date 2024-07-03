# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeServiceStep
                module Commands
                  class CalculateServiceResult < Support::Command
                    ##
                    # @!attribute [r] step
                    #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    #
                    attr_reader :step

                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize(step:)
                      @step = step
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotServiceStep]
                    #
                    # @internal
                    #   IMPORTANT: `service.result(**input_values)` is the reason, why services should have only kwargs as arguments.
                    #
                    def call
                      ::ConvenientService.raise Exceptions::StepIsNotServiceStep.new(step: step) unless step.service_step?

                      service.result(**input_values)
                    end

                    private

                    ##
                    # @return [ConvenientService::Service]
                    #
                    def service
                      @service ||= step.service_class
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def input_values
                      @input_values ||= step.input_values
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
