# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class FindLast < Support::Command
        attr_reader :array, :block

        def initialize(array, &block)
          @array = array
          @block = block
        end

        def call
          array.reverse.find(&block)
        end
      end
    end
  end
end
