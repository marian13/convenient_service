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
                  module Matchers
                    class WithAnyArguments < Chainings::Matchers::WithArguments
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
