# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Services
          class RunOwnMethodInOrganizer
            include Config

            attr_reader :method_name, :organizer, :kwargs

            def initialize(method_name:, organizer:, **kwargs)
              @method_name = method_name
              @organizer = organizer
              @kwargs = kwargs
            end

            def result
              own_method = Utils::Method.find_own(method_name, organizer)

              ##
              # NOTE: `kwargs' are intentionally NOT passed, since all the corresponding methods are available inside `own_method' body.
              #
              return own_method.call if own_method

              raise Errors::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name)
            end
          end
        end
      end
    end
  end
end
