# frozen_string_literal: true

require_relative "method/commands"
require_relative "method/concern"
require_relative "method/entities"
require_relative "method/errors"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            include Concern
          end
        end
      end
    end
  end
end
