# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "class/display_name"
require_relative "class/get_attached_object"

module ConvenientService
  module Utils
    module Class
      class << self
        ##
        # @api private
        #
        # @return [String]
        #
        def display_name(...)
          DisplayName.call(...)
        end

        ##
        # @api private
        #
        # @return [Class, nil]
        #
        def attached_object(...)
          GetAttachedObject.call(...)
        end
      end
    end
  end
end
