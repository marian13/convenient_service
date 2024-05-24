# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module CanBeExecuted
                  class Middleware < MethodChainMiddleware
                    intended_for :result, entity: :step

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined]
                    #
                    def next(...)
                      return chain.next(...) unless entity.method_step?

                      ::ConvenientService.raise Exceptions::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name) unless own_method

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
                      @organizer ||= entity.organizer
                    end

                    ##
                    # @return [Symbol]
                    #
                    def method_name
                      @method_name ||= entity.method
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def input_values
                      @input_values ||= entity.input_values
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
