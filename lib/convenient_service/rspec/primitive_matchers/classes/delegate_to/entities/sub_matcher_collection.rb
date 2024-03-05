# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class SubMatcherCollection
              ##
              # @api private
              #
              # @!attribute [r] block_expectation_value
              #   @return [Object]
              #
              attr_reader :block_expectation_value

              ##
              # @api private
              #
              # @!attribute [r] matcher
              #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers]
              #
              attr_reader :matcher

              ##
              # @api private
              #
              # @!attribute [r] sub_matchers
              #   @return [Hash]
              #
              attr_reader :sub_matchers

              ##
              # @api private
              #
              # @param matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
              # @return [void]
              #
              def initialize(matcher:)
                @matcher = matcher
                @sub_matchers = {}
              end

              ##
              # @api private
              #
              # @param block_expectation [Proc]
              # @return [Boolean]
              #
              def matches?(block_expectation)
                sub_matchers_ordered_by_index.each(&:apply_stubs!)

                @block_expectation_value = block_expectation.call

                sub_matchers_ordered_by_index.all? { |sub_matcher| sub_matcher.matches?(@block_expectation_value) }
              end

              ##
              # @api private
              #
              # @return [String]
              #
              def failure_message
                sub_matchers_ordered_by_index
                  .lazy
                  .reject { |sub_matcher| sub_matcher.matches?(block_expectation_value) }
                  .first
                  &.failure_message
                  .to_s
              end

              ##
              # @api private
              #
              # @return [String]
              #
              def failure_message_when_negated
                sub_matchers_ordered_by_index
                  .reject { |sub_matcher| sub_matcher.does_not_match?(block_expectation_value) }
                  .last
                  &.failure_message_when_negated
                  .to_s
              end

              ##
              # @api private
              #
              # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments]
              #
              def arguments
                sub_matchers[:arguments] ||= Entities::SubMatchers::WithAnyArguments.new(matcher: matcher)
              end

              ##
              # @api private
              #
              # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnValue, nil]
              #
              def return_value
                sub_matchers[:return_value]
              end

              ##
              # @api private
              #
              # @return [Array]
              #
              # @internal
              #   IMPORTANT: Order of sub matcher chainings matters.
              #
              def sub_matchers_ordered_by_index
                [arguments, return_value].compact
              end

              ##
              # @api private
              #
              # @return [Boolean]
              #
              def has_arguments?
                sub_matchers.has_key?(:arguments)
              end

              ##
              # @api private
              #
              # @return [Boolean]
              #
              def has_return_value?
                sub_matchers.has_key?(:return_value)
              end

              ##
              # @api private
              #
              # @param sub_matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments]
              #
              def arguments=(sub_matcher)
                sub_matchers[:arguments] = sub_matcher
              end

              ##
              # @api private
              #
              # @param sub_matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnValue]
              #
              def return_value=(sub_matcher)
                sub_matchers[:return_value] = sub_matcher
              end
            end
          end
        end
      end
    end
  end
end
