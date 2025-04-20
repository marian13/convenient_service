# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Arguments
      ##
      # @api private
      #
      class NullArguments < Support::Arguments
        ##
        # @return [void]
        #
        def initialize
          @args = []
          @kwargs = {}
          @block = nil
        end

        ##
        # @return [Boolean]
        #
        def null_arguments?
          true
        end
      end
    end
  end
end
