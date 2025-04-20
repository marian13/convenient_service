# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
