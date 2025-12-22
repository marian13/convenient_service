# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Array
      class FindLast < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array, Enumerable]
        #
        attr_reader :array

        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param array [Array, Enumerable]
        # @param block [Proc, nil]
        # @return [void]
        #
        def initialize(array, &block)
          @array = array
          @block = block
        end

        if Dependencies.ruby.version >= 4.0
          ##
          # @return [Object] Can be any type.
          #
          def call
            array.rfind(&block)
          end
        else
          ##
          # @return [Object] Can be any type.
          #
          def call
            array.reverse_each { |item| return item if block.call(item) }

            nil
          end
        end
      end
    end
  end
end
