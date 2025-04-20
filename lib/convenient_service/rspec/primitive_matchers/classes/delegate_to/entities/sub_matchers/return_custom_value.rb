# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class ReturnCustomValue < SubMatchers::Base
                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                # @internal
                #   TODO: Proper explanatory message when `matcher.inputs.custom_return_value` raises exception.
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
                  block_expectation_value == inputs.custom_return_value
                end

                ##
                # @return [String]
                #
                def failure_message
                  [failure_message_permanent_part, same_visual_output_note].reject(&:empty?).join("\n\n")
                end

                ##
                # @return [String]
                #
                def failure_message_when_negated
                  "expected `#{inputs.printable_block_expectation}` NOT to delegate to `#{inputs.printable_method}` and return custom value `#{inputs.custom_return_value.inspect}`, but it did."
                end

                private

                ##
                # @return [String]
                #
                def failure_message_permanent_part
                  <<~MESSAGE.chomp
                    expected `#{inputs.printable_block_expectation}` to delegate to `#{inputs.printable_method}` and return custom value `#{inputs.custom_return_value.inspect}`, but it didn't.

                    `#{inputs.printable_block_expectation}` returns `#{block_expectation_value.inspect}`.

                    Delegation returns `#{inputs.delegation_value.inspect}`.
                  MESSAGE
                end

                ##
                # @internal
                #   NOTE: Early return is harder to understand in this particular case, that is why a casual if is used.
                #
                #   def note
                #     return "" if block_expectation_value.inspect != matcher.custom_return_value.inspect
                #     return "" if block_expectation_value == matcher.custom_return_value
                #
                #     # ...
                #   end
                #
                def same_visual_output_note
                  if block_expectation_value.inspect == inputs.custom_return_value.inspect && block_expectation_value != inputs.custom_return_value
                    <<~MESSAGE.chomp
                      NOTE: Block expectation value `#{block_expectation_value.inspect}` and custom return value `#{inputs.custom_return_value.inspect}` have the same visual output, but they are different objects in terms of `#==`.

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
