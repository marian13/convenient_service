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
              class WithConcreteArguments < SubMatchers::Arguments
                ##
                # @return [Boolean]
                #
                def matches_arguments?(arguments)
                  Utils.to_bool(arguments == inputs.expected_arguments)
                end

                ##
                # @return [String]
                #
                def printable_expected_arguments
                  "with `#{Arguments::Commands::GeneratePrintableArguments.call(arguments: inputs.expected_arguments)}`"
                end
              end
            end
          end
        end
      end
    end
  end
end
