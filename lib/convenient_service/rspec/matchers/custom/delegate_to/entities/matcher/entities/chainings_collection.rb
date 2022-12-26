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
                  # @!attribute [r] call_original
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Base, nil]
                  attr_reader :call_original

                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Base, nil]
                  attr_reader :arguments

                  ##
                  # @!attribute [r] return_its_value
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Base, nil]
                  attr_reader :return_its_value

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
                    chainings.each(&:apply_stubs!)

                    @block_expectation_value = block_expectation.call

                    chainings.all? { |chaining| chaining.matches?(@block_expectation_value) }
                  end

                  ##
                  # @return [Boolean]
                  #
                  def should_call_original?
                    Utils::Bool.to_bool(call_original&.should_call_original?)
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message
                    chainings.find { |chaining| chaining.does_not_match?(block_expectation_value) }&.failure_message || ""
                  end

                  ##
                  # @return [String]
                  #
                  def failure_message_when_negated
                    chainings.find { |chaining| chaining.matches?(block_expectation_value) }&.failure_message_when_negated || ""
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
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def call_original=(chaining)
                    raise Errors::CallOriginalChainingIsAlreadySet.new if @call_original

                    @call_original = chaining
                  end

                  ##
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
                  #
                  def arguments=(chaining)
                    raise Errors::ArgumentsChainingIsAlreadySet.new if @arguments

                    @arguments = chaining
                  end

                  ##
                  # @param chaining [Class]
                  # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
                  #
                  def return_its_value=(chaining)
                    raise Errors::ReturnItsValueChainingIsAlreadySet.new if @return_its_value

                    @return_its_value = chaining
                  end

                  private

                  ##
                  # @return [Array]
                  #
                  # @internal
                  #   IMPORTANT: Order of chainings matters.
                  #
                  def chainings
                    [call_original, arguments, return_its_value].compact
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
