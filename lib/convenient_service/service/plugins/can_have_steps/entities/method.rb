# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "method/commands"
require_relative "method/concern"
require_relative "method/entities"
require_relative "method/exceptions"

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
