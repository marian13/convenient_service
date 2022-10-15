# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Services
          class RunOwnMethodInOrganizer
            include MethodStepConfig

            attr_reader :method_name, :organizer, :kwargs

            def initialize(method_name:, organizer:, **kwargs)
              @method_name = method_name
              @organizer = organizer
              @kwargs = kwargs
            end

            def result
              ##
              # @internal
              #   TODO: A possible bottleneck. Should be removed if receives negative feedback.
              #
              own_method = Utils::Module.get_own_instance_method(organizer.class, method_name, private: true)

              ##
              # @internal
              #   NOTE: `kwargs` are intentionally NOT passed, since all the corresponding methods are available inside `own_method` body.
              #   NOTE: `own_method.bind_call(organizer)` is logically the same as `own_method.bind(organizer).call`.
              #   - https://ruby-doc.org/core-2.7.1/UnboundMethod.html#method-i-bind_call
              #   - https://blog.saeloun.com/2019/10/17/ruby-2-7-adds-unboundmethod-bind_call-method.html
              #
              return own_method.bind_call(organizer) if own_method

              raise Errors::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name)
            end
          end
        end
      end
    end
  end
end
