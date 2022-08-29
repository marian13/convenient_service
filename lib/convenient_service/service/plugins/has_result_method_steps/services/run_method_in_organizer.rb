# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Services
          class RunMethodInOrganizer
            include Config

            attr_reader :method_name, :organizer, :kwargs

            def initialize(method_name:, organizer:, **kwargs)
              @method_name = method_name
              @organizer = organizer
              @kwargs = kwargs
            end

            def result
              ##
              # NOTE: `kwargs' are intentionally NOT passed, since all the corresponding methods are available inside `organizer.__send__(method_name)' body.
              #
              organizer.__send__(method_name)
            end
          end
        end
      end
    end
  end
end
