# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Array
      class DropWhile < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] inclusively
        #   @return [Boolean]
        #
        attr_reader :inclusively

        ##
        # @!attribute [r] condition_block
        #   @return [Proc]
        #
        attr_reader :condition_block

        ##
        # @param array [Array]
        # @param inclusively [Boolean]
        # @param condition_block [Proc]
        # @return [void]
        #
        def initialize(array, inclusively: false, &condition_block)
          @array = array
          @inclusively = inclusively
          @condition_block = condition_block
        end

        ##
        # @return [Array]
        #
        def call
          remained_items = array.drop_while(&condition_block)

          remained_items = remained_items.drop(1) if inclusively

          remained_items
        end
      end
    end
  end
end
