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
                    class ReturnDelegationValue < Chainings::SubMatchers::ReturnValue
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
                        # TODO: `with_warmup`.
                        #
                        # IMPORTANT: `and_return_its_value` works only when `delegate_to` checks a pure function.
                        #
                        # For example (1):
                        #   def require_dependencies_pure
                        #     RequireDependenciesPure.call
                        #   end
                        #
                        #   class RequireDependenciesPure
                        #     def self.call
                        #       dependencies.require!
                        #
                        #       true
                        #     end
                        #   end
                        #
                        #   # Works since `RequireDependenciesPure.call` always returns `true`.
                        #   specify do
                        #     expect { require_dependencies_pure }
                        #       .to delegate_to(RequireDependenciesPure, :call)
                        #       .and_return_its_value
                        #   end
                        #
                        # Example (2):
                        #   def require_dependencies_not_pure
                        #     RequireDependenciesNotPure.call
                        #   end
                        #
                        #   class RequireDependenciesNotPure
                        #     def self.call
                        #       return false if dependencies.required?
                        #
                        #       dependencies.require!
                        #
                        #       true
                        #     end
                        #   end
                        #
                        #   # Does NOT work since `RequireDependenciesNotPure.call` returns `true` for the first time and `false` for the subsequent call.
                        #   specify do
                        #     expect { require_dependencies_not_pure }
                        #       .to delegate_to(RequireDependenciesNotPure, :call)
                        #       .and_return_its_value
                        #   end
                        #
                        block_expectation_value == matcher.delegation_value
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
