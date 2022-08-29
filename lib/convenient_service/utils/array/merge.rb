# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class Merge < Support::Command
        attr_reader :array, :overrides, :raise_on_non_integer_index

        def initialize(array, overrides, raise_on_non_integer_index:)
          @array = array
          @overrides = overrides
          @raise_on_non_integer_index = raise_on_non_integer_index
        end

        def call
          ensure_valid_overrides!

          integer_key_overrides.each_with_object(array.dup) { |(index, value), array| array[index] = value }
        end

        private

        def ensure_valid_overrides!
          return integer_key_overrides unless raise_on_non_integer_index

          return if overrides.size == integer_key_overrides.size

          raise Errors::NonIntegerIndex.new(index: non_integer_index)
        end

        def integer_key_overrides
          @integer_key_overrides ||= overrides.dup.keep_if { |index| index.is_a?(::Integer) }
        end

        ##
        #
        #
        def non_integer_index
          @non_integer_index ||= overrides.keys.find { |index| !index.is_a?(::Integer) }
        end
      end
    end
  end
end
