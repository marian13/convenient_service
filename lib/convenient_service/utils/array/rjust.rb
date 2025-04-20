# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Array
      class Rjust < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] size
        #   @return [Integer]
        #
        attr_reader :size

        ##
        # @!attribute [r] pad
        #   @return [Object] Can be any type.
        #
        attr_reader :pad

        ##
        # @param array [Array]
        # @param size [Integer]
        # @param pad [Object] Can be any type.
        # @return [void]
        #
        def initialize(array, size, pad = nil)
          @array = array
          @size = size
          @pad = pad
        end

        ##
        # @return [Array]
        #
        def call
          return array if size <= array.size

          count = size - array.size

          array + [pad] * count
        end
      end
    end
  end
end
