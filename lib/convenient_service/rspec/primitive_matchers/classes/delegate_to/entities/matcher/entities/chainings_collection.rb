# frozen_string_literal: true

require_relative "chainings_collection/exceptions"

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class ChainingsCollection
                  include Support::Delegate

                  ##
                  # @!attribute [r] matcher
                  #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings]
                  #
                  attr_reader :matcher

                  ##
                  # @!attribute [r] block_expectation_value
                  #   @return [Object]
                  #
                  attr_reader :block_expectation_value

                  ##
                  # @!attribute [r] call_original
                  #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::Values::Base, nil]
                  #
                  attr_reader :call_original

                  ##
                  # @!attribute [r] comparing_by
                  #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::Values::ComparisonMethod, nil]
                  #
                  attr_reader :comparing_by

                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::Arguments, nil]
                  #
                  attr_reader :arguments

                  ##
                  # @!attribute [r] return_value
                  #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::ReturnValue, nil]
                  #
                  attr_reader :return_value

                  ##
                  # @param matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher]
                  # @return [void]
                  #
                  def initialize(matcher:)
                    @matcher = matcher
                  end

                  ##
                  # @param block_expectation [Proc]
                  # @return [Boolean]
                  #
                  def sub_matchers_match?(block_expectation)
                    sub_matchers.each(&:apply_stubs!)

                    @block_expectation_value = block_expectation.call

                    sub_matchers.all? { |sub_matcher| sub_matcher.matches?(@block_expectation_value) }
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message
                    sub_matchers
                      .lazy
                      .reject { |sub_matcher| sub_matcher.matches?(block_expectation_value) }
                      .first
                      &.failure_message
                      .to_s
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message_when_negated
                    sub_matchers
                      .reject { |sub_matcher| sub_matcher.does_not_match?(block_expectation_value) }
                      .last
                      &.failure_message_when_negated
                      .to_s
                  end

                  ##
                  # @return [Array]
                  #
                  # @internal
                  #   IMPORTANT: Order of sub matcher chainings matters.
                  #
                  def sub_matchers
                    [arguments, return_value].compact
                  end

                  ##
                  # @return [Array]
                  #
                  # @internal
                  #   TODO: Consider to remove.
                  #
                  def values
                    [call_original, comparing_by].compact
                  end

                  ##
                  # @return [Boolean]
                  #
                  def should_call_original?
                    Utils.to_bool(call_original&.value)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_call_original?
                    Utils.to_bool(call_original)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_comparing_by?
                    Utils.to_bool(comparing_by)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_arguments?
                    Utils.to_bool(arguments)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_return_value?
                    Utils.to_bool(return_value)
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::Values::Base]
                  # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ReturnItsValueChainingIsAlreadySet]
                  #
                  def call_original=(chaining)
                    ::ConvenientService.raise Exceptions::CallOriginalChainingIsAlreadySet.new if @call_original

                    @call_original = chaining
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::Arguments]
                  # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
                  #
                  def arguments=(chaining)
                    ::ConvenientService.raise Exceptions::ArgumentsChainingIsAlreadySet.new if @arguments

                    @arguments = chaining
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::ReturnValue]
                  # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ReturnValueChainingIsAlreadySet]
                  #
                  def return_value=(chaining)
                    ::ConvenientService.raise Exceptions::ReturnValueChainingIsAlreadySet.new if @return_value

                    @return_value = chaining
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::Values::ComparisonMethod]
                  # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ComparingByChainingIsAlreadySet]
                  #
                  def comparing_by=(chaining)
                    ::ConvenientService.raise Exceptions::ComparingByChainingIsAlreadySet.new if @comparing_by

                    @comparing_by = chaining
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
