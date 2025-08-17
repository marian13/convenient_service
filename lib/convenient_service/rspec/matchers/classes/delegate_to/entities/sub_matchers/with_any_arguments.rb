# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class WithAnyArguments < SubMatchers::Arguments
                ##
                # @return [Boolean]
                #
                def matches_arguments?(arguments)
                  true
                end

                ##
                # @return [String]
                #
                def printable_expected_arguments
                  "with any arguments (no arguments is also valid)"
                end
              end
            end
          end
        end
      end
    end
  end
end
