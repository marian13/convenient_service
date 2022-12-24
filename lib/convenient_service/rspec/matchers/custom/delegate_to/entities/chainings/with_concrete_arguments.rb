# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class WithConcreteArguments < Chainings::Base
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

                  matcher.delegations.any? { |delegation| delegation.arguments == matcher.expected_arguments }
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
                  "expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` with `#{matcher.printable_expected_arguments}` at least once, but it did."
                end

                private

                def failure_message_expected_part
                  "expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` with `#{matcher.printable_expected_arguments}` at least once, but it didn't."
                end

                ##
                # @return [String]
                #
                # @internal
                #   TODO: String diff.
                #
                def failure_message_got_part
                  if matcher.delegations.any?
                    "got delegated with #{matcher.printable_actual_arguments}"
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
