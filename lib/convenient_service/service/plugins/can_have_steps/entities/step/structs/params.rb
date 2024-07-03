# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Structs
              Params = ::Struct.new(:action, :inputs, :outputs, :index, :container, :organizer, :extra_kwargs, keyword_init: true)
            end
          end
        end
      end
    end
  end
end
