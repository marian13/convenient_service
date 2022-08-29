# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Step
            module Structs
              Params = Support::Struct.new(:service, :inputs, :outputs, :index, :container, :organizer, keyword_init: true)
            end
          end
        end
      end
    end
  end
end
