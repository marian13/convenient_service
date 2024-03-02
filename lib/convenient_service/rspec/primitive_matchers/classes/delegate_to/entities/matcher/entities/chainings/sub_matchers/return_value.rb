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
                    class ReturnValue < Chainings::SubMatchers::Base
                      ##
                      # @param block_expectation_value [Object]
                      # @return [Boolean]
                      #
                      def matches?(block_expectation_value)
                        super
                      end

                      ##
                      # @return [String]
                      #
                      def failure_message
                        [failure_message_permanent_part, same_visual_output_note].reject(&:empty?).join("\n\n")
                      end

                      private

                      ##
                      # @internal
                      #   NOTE: Early return is harder to understand in this particular case, that is why a casual if is used.
                      #
                      #   def note
                      #     return "" if block_expectation_value.inspect != matcher.delegation_value.inspect
                      #     return "" if block_expectation_value == matcher.delegation_value
                      #
                      #     # ...
                      #   end
                      #
                      def same_visual_output_note
                        if block_expectation_value.inspect == matcher.delegation_value.inspect && block_expectation_value != matcher.delegation_value
                          <<~MESSAGE.chomp
                            NOTE: `#{block_expectation_value.inspect}` and `#{matcher.delegation_value.inspect}` have the same visual output, but they are different objects in terms of `#==`.

                            If it is expected behavior, ignore this note.

                            Otherwise, define a meaningful `#==` for `#{block_expectation_value.class}` or adjust its `#inspect` to generate different output.
                          MESSAGE
                        else
                          ""
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
end
