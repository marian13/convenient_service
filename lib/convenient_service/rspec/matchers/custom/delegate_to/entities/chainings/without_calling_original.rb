# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class WithoutCallingOriginal
                include Support::Delegate

                ##
                # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                #
                attr_reader :matcher

                ##
                # @return [Object]
                #
                attr_reader :block_expectation_value

                ##
                # @return [Object]
                #
                delegate :object, to: :matcher

                ##
                # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                # @return [void]
                #
                def initialize(matcher:)
                  @matcher = matcher
                end

                ##
                # @return [true]
                #
                def should_call_original?
                  false
                end

                ##
                # @return [void]
                #
                def apply_mocks!
                end

                ##
                # @param block_expectation_value [Object]
                # @return [true]
                #
                def matches?(block_expectation_value)
                  @block_expectation_value = block_expectation_value

                  true
                end

                ##
                # @param value [Object]
                # @return [Boolean]
                #
                def does_not_match?(value)
                  !matches?(value)
                end

                ##
                # @return [String]
                #
                def failure_message
                  ""
                end

                ##
                # @return [String]
                #
                def failure_message_when_negated
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
