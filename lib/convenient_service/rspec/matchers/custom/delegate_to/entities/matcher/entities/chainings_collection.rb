# frozen_string_literal: true

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
                  # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings]
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
                    chainings.values.each(&:apply_stubs!)

                    @block_expectation_value = block_expectation.call

                    chainings.values.all? { |chaining| chaining.matches?(@block_expectation_value) }
                  end

                  ##
                  # @return [Boolean]
                  #
                  def should_call_original?
                    return false unless chainings.has_key?(:call_original)
                    return false unless chainings[:call_original].should_call_original?

                    true
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message
                    chainings.values.find { |chaining| chaining.does_not_match?(block_expectation_value) }&.failure_message || ""
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message_when_negated
                    chainings.values.find { |chaining| chaining.matches?(block_expectation_value) }&.failure_message_when_negated || ""
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_arguments_chaining?
                    chainings.has_key?(:arguments)
                  end

                  ##
                  # @return [Boolean]
                  #
                  def has_call_original_chaining?
                    chainings.has_key?(:call_original)
                  end

                  ##
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
                  #
                  def add_arguments_chaining(chaining)
                    raise Errors::ArgumentsChainingIsAlreadySet.new if chainings.has_key?(:arguments)

                    chainings[:arguments] = chaining.new(matcher: matcher)
                  end

                  ##
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def add_return_its_value_chaining(chaining)
                    raise Errors::ReturnItsValueChainingIsAlreadySet.new if chainings.has_key?(:return_its_value)

                    chainings[:return_its_value] = chaining.new(matcher: matcher)
                  end

                  ##
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def add_call_original_chaining(chaining)
                    raise Errors::CallOriginalChainingIsAlreadySet.new if chainings.has_key?(:call_original)

                    chainings[:call_original] = chaining.new(matcher: matcher)
                  end

                  private

                  ##
                  # @return [Array]
                  #
                  def chainings
                    @chainings ||= {}
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
