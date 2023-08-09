# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class Merge < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] overrides
        #   @return [Hash]
        #
        attr_reader :overrides

        ##
        # @!attribute [r] raise_on_non_integer_index
        #   @return [Boolean]
        #
        attr_reader :raise_on_non_integer_index

        ##
        # @param array [Array]
        # @param overrides [Hash]
        # @param raise_on_non_integer_index [Boolean]
        # @return [void]
        #
        def initialize(array, overrides, raise_on_non_integer_index: true)
          @array = array
          @overrides = overrides
          @raise_on_non_integer_index = raise_on_non_integer_index
        end

        ##
        # @return [Array]
        # @raise [ConvenientService::Utils::Array::Exceptions::NonIntegerIndex]
        #
        def call
          ensure_valid_overrides!

          integer_key_overrides.each_with_object(array.dup) { |(index, value), array| array[index] = value }
        end

        private

        ##
        # @return [void]
        # @raise [ConvenientService::Utils::Array::Exceptions::NonIntegerIndex]
        #
        def ensure_valid_overrides!
          return integer_key_overrides unless raise_on_non_integer_index

          return if overrides.size == integer_key_overrides.size

          raise Exceptions::NonIntegerIndex.new(index: non_integer_index)
        end

        ##
        # @return [Hash]
        #
        def integer_key_overrides
          @integer_key_overrides ||= overrides.dup.keep_if { |index| index.is_a?(::Integer) }
        end

        ##
        # @return [Object] Can be any type.
        #
        def non_integer_index
          @non_integer_index ||= overrides.keys.find { |index| !index.is_a?(::Integer) }
        end
      end
    end
  end
end
