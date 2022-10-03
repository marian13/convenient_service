# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class DropWhile < Support::Command
        attr_reader :array, :inclusively, :condition_block

        def initialize(array, inclusively:, &condition_block)
          @array = array
          @inclusively = inclusively
          @condition_block = condition_block
        end

        def call
          remained_items = array.drop_while(&condition_block)

          remained_items = remained_items.drop(1) if inclusively

          remained_items
        end
      end
    end
  end
end
