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
                    class WithConcreteArguments < Chainings::Matchers::WithArguments
                      ##
                      # @return [Boolean]
                      #
                      def matches_arguments?(arguments)
                        arguments == matcher.expected_arguments
                      end

                      ##
                      # @return [String]
                      #
                      def printable_expected_arguments
                        "with `#{Commands::GeneratePrintableArguments.call(arguments: matcher.expected_arguments)}`"
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
