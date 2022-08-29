# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class RJust < Support::Command
        attr_reader :array, :size, :pad

        def initialize(array, size, pad)
          @array = array
          @size = size
          @pad = pad
        end

        def call
          return array if size <= array.size

          count = size - array.size

          array + [pad] * count
        end
      end
    end
  end
end
