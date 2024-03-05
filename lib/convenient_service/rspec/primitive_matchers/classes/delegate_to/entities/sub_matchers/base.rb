# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class Base
                ##
                # @!attribute [r] block_expectation_value
                #   @return [Object] Can be any type.
                #
                attr_reader :block_expectation_value

                ##
                # @!attribute [r] matcher
                #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
                #
                attr_reader :matcher

                ##
                # @overload initialize(matcher:)
                #   @param matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
                #   @return [void]
                #
                # @overload initialize(matcher:, block_expectation_value:)
                #   @param matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
                #   @param block_expectation_value [Object] Can be any type.
                #   @return [void]
                #   @api private
                #
                def initialize(matcher:, block_expectation_value: nil)
                  @matcher = matcher
                  @block_expectation_value = block_expectation_value
                end

                ##
                # @return [void]
                #
                def apply_stubs!
                end

                ##
                # @param block_expectation_value [Object] Can be any type.
                # @return [Boolean]
                #
                def matches?(block_expectation_value)
                  @block_expectation_value = block_expectation_value

                  false
                end

                ##
                # @param block_expectation_value [Object] Can be any type.
                # @return [Boolean]
                #
                def does_not_match?(block_expectation_value)
                  !matches?(block_expectation_value)
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

                private

                ##
                # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Inputs]
                #
                def inputs
                  matcher.inputs
                end
              end
            end
          end
        end
      end
    end
  end
end
