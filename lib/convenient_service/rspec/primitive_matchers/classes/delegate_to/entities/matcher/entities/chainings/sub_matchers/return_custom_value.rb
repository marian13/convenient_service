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
                    class ReturnCustomValue < Chainings::SubMatchers::ReturnValue
                      ##
                      # @param block_expectation_value [Object]
                      # @return [Boolean]
                      #
                      # @internal
                      #   TODO: Proper explanatory message when `matcher.delegation_value` raises exception.
                      #
                      def matches?(block_expectation_value)
                        super

                        ##
                        #   specify do
                        #     expect { require_dependencies_not_pure }
                        #       .to delegate_to(RequireDependenciesNotPure, :call)
                        #       .and_return { |delegation_value| delegation_value.to_s }
                        #   end
                        #
                        block_expectation_value == matcher.expected_return_value_block.call(matcher.delegation_value)
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
