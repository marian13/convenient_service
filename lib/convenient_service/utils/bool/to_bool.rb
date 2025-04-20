# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Bool
      ##
      # Converts objects to boolean.
      # Implementation is very basic just to serve the need of this library.
      # More comprehensive solution can be found in Rails, wannabe_bool, etc:
      # - https://api.rubyonrails.org/classes/ActiveModel/Type/Boolean.html
      # - https://github.com/prodis/wannabe_bool
      #
      class ToBool < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @param object [Object] Can be any type.
        # @return [void]
        #
        def initialize(object)
          @object = object
        end

        ##
        # @return [Boolean]
        #
        def call
          !!object
        end
      end
    end
  end
end
