# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class ReturnDelegationValue < SubMatchers::Base
                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                # @internal
                #   TODO: Proper explanatory message when `inputs.delegation_value` raises exception.
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
                  block_expectation_value == inputs.delegation_value
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
                  "expected `#{inputs.printable_block_expectation}` NOT to delegate to `#{inputs.printable_method}` and return its value, but it did."
                end

                private

                ##
                # @return [String]
                #
                def failure_message_permanent_part
                  <<~MESSAGE.chomp
                    expected `#{inputs.printable_block_expectation}` to delegate to `#{inputs.printable_method}` and return its value, but it didn't.

                    `#{inputs.printable_block_expectation}` returns `#{block_expectation_value.inspect}`, but delegation returns `#{inputs.delegation_value.inspect}`.
                  MESSAGE
                end

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
                  if block_expectation_value.inspect == inputs.delegation_value.inspect && block_expectation_value != inputs.delegation_value
                    <<~MESSAGE.chomp
                      NOTE: Block expectation value `#{block_expectation_value.inspect}` and delegation value `#{inputs.delegation_value.inspect}` have the same visual output, but they are different objects in terms of `#==`.

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
