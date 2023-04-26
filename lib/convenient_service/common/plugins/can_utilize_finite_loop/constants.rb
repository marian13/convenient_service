# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanUtilizeFiniteLoop
        module Constants
          ##
          # @return [ConvenientService::Support::UniqueValue]
          #
          FINITE_LOOP_EXCEEDED = Support::UniqueValue.new("finite_loop_exceeded")

          ##
          # @return [Integer]
          #
          MAX_ITERATION_COUNT = 1_000
        end
      end
    end
  end
end
