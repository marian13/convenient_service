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
              class WithoutArguments < SubMatchers::Arguments
                ##
                # @return [Boolean]
                #
                def matches_arguments?(arguments)
                  arguments.none?
                end

                ##
                # @return [String]
                #
                def printable_expected_arguments
                  "without arguments"
                end
              end
            end
          end
        end
      end
    end
  end
end
