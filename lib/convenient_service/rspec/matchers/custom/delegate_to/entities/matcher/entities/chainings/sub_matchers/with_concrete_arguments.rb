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
                    class WithConcreteArguments < Chainings::SubMatchers::WithArguments
                      ##
                      # @return [Boolean]
                      #
                      def matches_arguments?(arguments)
                        Utils::Bool.to_bool(arguments == matcher.expected_arguments)
                      end

                      ##
                      # @return [String]
                      #
                      def printable_expected_arguments
                        "with `#{WithArguments::Commands::GeneratePrintableArguments.call(arguments: matcher.expected_arguments)}`"
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
