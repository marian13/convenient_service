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
              raise Errors::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name) unless own_method

              ##
              # NOTE: `kwargs` are intentionally NOT passed, since all the corresponding methods are available inside `own_method` body.
              #
              own_method.call
            end

            private

            ##
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
          end
        end
      end
    end
  end
end
