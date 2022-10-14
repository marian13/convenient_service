# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class FindLast < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param array [Array]
        # @param block [Proc]
        # @return [void]
        #
        def initialize(array, &block)
          @array = array
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        def call
          array.reverse.find(&block)
        end
      end
    end
  end
end
