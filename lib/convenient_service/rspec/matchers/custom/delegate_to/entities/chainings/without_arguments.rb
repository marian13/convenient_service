# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class WithoutArguments < Chainings::Base
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

                  matcher.delegations.any?
                end

                ##
                # @return [String]
                #
                def failure_message
                  "expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` without arguments at least once, but it didn't."
                end

                ##
                # @return [String]
                #
                def failure_message_when_negated
                  "expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` without arguments at least once, but it did."
                end
              end
            end
          end
        end
      end
    end
  end
end
