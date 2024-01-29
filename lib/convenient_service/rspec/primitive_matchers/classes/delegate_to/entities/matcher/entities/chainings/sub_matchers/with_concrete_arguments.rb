# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module SubMatchers
                    class WithConcreteArguments < Chainings::SubMatchers::Arguments
                      ##
                      # @return [Boolean]
                      #
                      # @internal
                      #   TODO: Specs for `comparison_method`.
                      #
                      def matches_arguments?(arguments)
                        Utils.to_bool(matcher.expected_arguments.public_send(matcher.comparison_method, arguments))
                      end

                      ##
                      # @return [String]
                      #
                      def printable_expected_arguments
                        "with `#{Arguments::Commands::GeneratePrintableArguments.call(arguments: matcher.expected_arguments)}`"
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
