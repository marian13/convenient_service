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
                        block_expectation_value == matcher.custom_return_value
                      end

                      ##
                      # @return [String]
                      #
                      def failure_message_when_negated
                        "expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` and return custom value `#{matcher.custom_return_value}`, but it did."
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def failure_message_permanent_part
                        <<~MESSAGE.chomp
                          expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` and return custom value `#{matcher.custom_return_value}`, but it didn't.

                          `#{matcher.printable_block_expectation}` returns `#{block_expectation_value.inspect}`, but delegation returns `#{matcher.delegation_value.inspect}`.
                        MESSAGE
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
