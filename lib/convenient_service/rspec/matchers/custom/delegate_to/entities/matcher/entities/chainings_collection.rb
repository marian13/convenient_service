# frozen_string_literal: true

require_relative "chainings_collection/errors"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class ChainingsCollection
                  include Support::Delegate

                  ##
                  # @!attribute [r] matcher
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings]
                  #
                  attr_reader :matcher

                  ##
                  # @!attribute [r] block_expectation_value
                  #   @return [Object]
                  #
                  attr_reader :block_expectation_value

                  ##
                  # @!attribute [r] call_original
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions:Base, nil]
                  #
                  attr_reader :call_original

                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::Base, nil]
                  #
                  attr_reader :arguments

                  ##
                  # @!attribute [r] return_its_value
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::Base, nil]
                  #
                  attr_reader :return_its_value

                  ##
                  # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
                  # @return [void]
                  #
                  def initialize(matcher:)
                    @matcher = matcher
                  end

                  ##
                  # @param block_expectation [Proc]
                  # @return [Boolean]
                  #
                  def matches?(block_expectation)
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
                  def permissions
                    [call_original].compact
                  end

                  ##
                  # @return [Array]
                  #
                  # @internal
                  #   IMPORTANT: Order of sub matcher chainings matters.
                  #
                  def sub_matchers
                    [arguments, return_its_value].compact
                  end

                  ##
                  # @return [Boolean]
                  #
                  def should_call_original?
                    Utils::Bool.to_bool(call_original&.allows?)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_call_original?
                    Utils::Bool.to_bool(call_original)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_arguments?
                    Utils::Bool.to_bool(arguments)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_return_its_value?
                    Utils::Bool.to_bool(return_its_value)
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Permissions::Base]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def call_original=(chaining)
                    raise Errors::CallOriginalChainingIsAlreadySet.new if @call_original

                    @call_original = chaining
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::Base]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
                  #
                  def arguments=(chaining)
                    raise Errors::ArgumentsChainingIsAlreadySet.new if @arguments

                    @arguments = chaining
                  end

                  ##
                  # @param chaining [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::Base]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def return_its_value=(chaining)
                    raise Errors::ReturnItsValueChainingIsAlreadySet.new if @return_its_value

                    @return_its_value = chaining
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
