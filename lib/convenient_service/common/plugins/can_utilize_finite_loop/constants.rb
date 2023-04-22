# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanUtilizeFiniteLoop
        module Constants
          FINITE_LOOP_EXCEEDED = Support::UniqueValue.new("finite_loop_exceeded")

          MAX_ITERATION_COUNT = 1_000
        end
      end
    end
  end
end
