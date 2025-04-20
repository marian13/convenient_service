# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "arguments/commands"

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class Arguments < SubMatchers::Base
                ##
                # @return [void]
                #
                def apply_stubs!
                  Commands::ApplyStubToTrackDelegations.call(matcher: matcher)
                end

                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                def matches?(block_expectation_value)
                  super

                  outputs.delegations.any? { |delegation| matches_arguments?(delegation.arguments) }
                end

                ##
                # @return [String]
                #
                # @internal
                #   TODO: Prettier message.
                #
                def failure_message
                  <<~MESSAGE.chomp
                    #{failure_message_expected_part}

                    #{failure_message_got_part}
                  MESSAGE
                end

                ##
                # @return [String]
                #
                def failure_message_when_negated
                  "expected `#{inputs.printable_block_expectation}` NOT to delegate to `#{inputs.printable_method}` #{printable_expected_arguments} at least once, but it did."
                end

                ##
                # @return [String]
                #
                def printable_actual_arguments
                  return "" if outputs.delegations.none?

                  outputs.delegations
                    .map { |delegation| Commands::GeneratePrintableArguments.call(arguments: delegation.arguments) }
                    .join(", ")
                    .prepend("with ")
                end

                private

                def failure_message_expected_part
                  "expected `#{inputs.printable_block_expectation}` to delegate to `#{inputs.printable_method}` #{printable_expected_arguments} at least once, but it didn't."
                end

                ##
                # @return [String]
                #
                # @internal
                #   TODO: String diff.
                #
                def failure_message_got_part
                  if outputs.delegations.any?
                    "got delegated #{printable_actual_arguments}"
                  else
                    "got not delegated at all"
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
