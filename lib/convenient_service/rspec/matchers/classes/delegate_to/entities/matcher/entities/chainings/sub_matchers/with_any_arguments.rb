# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module SubMatchers
                    class WithAnyArguments < Chainings::SubMatchers::Arguments
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
    end
  end
end
