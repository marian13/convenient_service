# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
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
