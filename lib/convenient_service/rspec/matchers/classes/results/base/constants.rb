# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Constants
              module Triggers
                ##
                # @api private
                #
                # @return [ConvenientService::Support::UniqueValue]
                #
                BE_RESULT = Support::UniqueValue.new("BE_RESULT")
              end

              ##
              # @api private
              #
              # @return [Symbol]
              #
              DEFAULT_COMPARISON_METHOD = :==
            end
          end
        end
      end
    end
  end
end
