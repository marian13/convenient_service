# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
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
