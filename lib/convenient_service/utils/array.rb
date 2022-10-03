# frozen_string_literal: true

require_relative "array/errors"

require_relative "array/contain_exactly"
require_relative "array/drop_while"
require_relative "array/find_last"
require_relative "array/merge"
require_relative "array/rjust"
require_relative "array/wrap"

module ConvenientService
  module Utils
    module Array
      class << self
        def contain_exactly?(first_array, second_array)
          ContainExactly.call(first_array, second_array)
        end

        ##
        # @param array [Array]
        # @param inclusively [Boolean]
        # @param condition_block [Proc]
        # @return [Array]
        #
        def drop_while(array, inclusively: false, &condition_block)
          DropWhile.call(array, inclusively: inclusively, &condition_block)
        end

        def find_last(array, &block)
          FindLast.call(array, &block)
        end

        def merge(array, overrides, raise_on_non_integer_index: true)
          Merge.call(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index)
        end

        def rjust(array, size, pad = nil)
          RJust.call(array, size, pad)
        end

        def wrap(object)
          Wrap.call(object)
        end
      end
    end
  end
end
