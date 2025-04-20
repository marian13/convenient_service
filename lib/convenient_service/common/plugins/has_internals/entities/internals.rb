# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "internals/concern"
require_relative "internals/plugins"

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            include Concern
          end
        end
      end
    end
  end
end
