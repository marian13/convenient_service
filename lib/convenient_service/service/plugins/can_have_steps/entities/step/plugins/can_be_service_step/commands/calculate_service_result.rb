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
                    def call
                      ::ConvenientService.raise Exceptions::StepIsNotServiceStep.new(step: step) unless step.service_step?

                      service.result(*input_arguments.args, **input_arguments.kwargs, &input_arguments.block)
                    end

                    private

                    ##
                    # @return [ConvenientService::Service]
                    #
                    def service
                      @service ||= step.service_class
                    end

                    ##
                    # @return [ConvenientService::Support::Arguments]
                    #
                    def input_arguments
                      @input_arguments ||= step.input_arguments
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
