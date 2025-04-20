# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
