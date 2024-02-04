# frozen_string_literal: true

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

        ##
        # @return [Object] Can be any type.
        #
        # @note Works with custom `Enumerable` objects.
        # @see https://ruby-doc.org/core-2.7.0/Enumerable.html
        #
        def call
          array.reverse_each { |item| return item if block.call(item) }

          nil
        end
      end
    end
  end
end
