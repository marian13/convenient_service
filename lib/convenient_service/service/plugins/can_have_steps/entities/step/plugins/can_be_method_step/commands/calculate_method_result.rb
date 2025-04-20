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
              module CanBeMethodStep
                module Commands
                  class CalculateMethodResult < Support::Command
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
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::StepIsNotMethodStep, ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions::MethodForStepIsNotDefined]
                    #
                    def call
                      ::ConvenientService.raise Exceptions::StepIsNotMethodStep.new(step: step) unless step.method_step?
                      ::ConvenientService.raise Exceptions::MethodForStepIsNotDefined.new(step: step) unless own_method

                      call_method(own_method)
                    end

                    private

                    ##
                    # @param method [Method]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def call_method(method)
                      params = Support::MethodParameters.new(method.parameters)

                      return method.call(**input_values) if params.has_rest_kwargs?

                      return method.call(**input_values.slice(*params.named_kwargs_keys)) if params.named_kwargs_keys.any?

                      method.call
                    end

                    ##
                    # @return [Method, nil]
                    #
                    # @internal
                    #   TODO: A possible bottleneck. Should be removed if receives negative feedback.
                    #
                    def own_method
                      Utils.memoize_including_falsy_values(self, :@own_method) { Utils::Object.own_method(organizer, method_name, private: true) }
                    end

                    ##
                    # @return [ConvenientService::Service]
                    #
                    def organizer
                      @organizer ||= step.organizer
                    end

                    ##
                    # @return [Symbol]
                    #
                    def method_name
                      @method_name ||= step.method
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
