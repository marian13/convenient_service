# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module SubMatchers
                    class WithoutArguments < Chainings::SubMatchers::Arguments
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
    end
  end
end
