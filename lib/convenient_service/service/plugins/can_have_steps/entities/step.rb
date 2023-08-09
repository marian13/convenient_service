# frozen_string_literal: true

require_relative "step/commands"
require_relative "step/concern"
require_relative "step/exceptions"
require_relative "step/plugins"
require_relative "step/structs"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            include Concern
          end
        end
      end
    end
  end
end
