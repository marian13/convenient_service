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
                    # @internal
                    #   NOTE: `kwargs` are intentionally NOT passed to `own_method.call`, since all the corresponding methods are available inside `own_method` body.
                    #
                    def next(...)
                      return chain.next(...) unless entity.method_step?

                      ::ConvenientService.raise Exceptions::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name) unless own_method

                      own_method.call
                    end

                    private

                    ##
                    # @return [Method, nil]
                    #
                    # @internal
                    #   TODO: A possible bottleneck. Should be removed if receives negative feedback.
                    #
                    #   NOTE: `own_method.bind(organizer).call` is logically the same as `own_method.bind_call(organizer)`.
                    #   - https://ruby-doc.org/core-2.7.1/UnboundMethod.html#method-i-bind_call
                    #   - https://blog.saeloun.com/2019/10/17/ruby-2-7-adds-unboundmethod-bind_call-method.html
                    #
                    def own_method
                      method = Utils::Module.get_own_instance_method(organizer.class, method_name, private: true)

                      return unless method

                      method.bind(organizer)
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
