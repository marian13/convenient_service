# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              ##
              # @!attribute [r] object
              #   @return [Object]
              #
              attr_reader :object

              ##
              # @!attribute [r] method
              #   @return [String, Symbol]
              #
              attr_reader :method

              ##
              # @!attribute [r] value
              #   @return [Object]
              #
              attr_reader :value

              ##
              # @param object [Object]
              # @param method [String, Symbol]
              # @return [void]
              #
              def initialize(object:, method:)
                @object = object
                @method = method
              end

              ##
              # @param block_expectation [Proc]
              # @return [Boolean]
              #
              def matches?(block_expectation)
                chainings.values.each(&:apply_mocks!)

                @value = block_expectation.call

                chainings.values.all? { |chaining| chaining.matches?(@value) }
              end

              ##
              # @return [String]
              #
              def description
                "delegate to `#{printable_method}`"
              end

              ##
              # @return [String]
              #
              def failure_message
                chainings.values.find { |chaining| chaining.does_not_match?(value) }&.failure_message || ""
              end

              ##
              # @return [String]
              #
              def failure_message_when_negated
                chainings.values.find { |chaining| chaining.matches?(value) }&.failure_message_when_negated || ""
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments]
              #
              def expected_arguments
                @expected_arguments ||= Entities::Arguments.new
              end

              ##
              # @param arguments [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments]
              # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments]
              #
              def expected_arguments=(arguments)
                @expected_arguments = arguments
              end

              ##
              # @return [Boolean]
              #
              def has_arguments_chaining?
                chainings.has_key?(:arguments)
              end

              ##
              # @param chaining [Class]
              # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
              #
              def add_arguments_chaining(chaining)
                raise Errors::ArgumentsChainingIsAlreadySet.new if chainings.has_key?(:arguments)

                chainings[:arguments] = chaining.new(matcher: self)
              end

              ##
              # @param chaining [Class]
              # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
              #
              def add_return_its_value_chaining(chaining)
                raise Errors::ReturnItsValueChainingIsAlreadySet.new if chainings.has_key?(:return_its_value)

                chainings[:return_its_value] = chaining.new(matcher: self)
              end

              ##
              # @return [Array]
              #
              def chainings
                @chainings ||= {}
              end

              ##
              # @return [Array]
              #
              def delegations
                @delegations ||= []
              end

              ##
              # @return [String]
              #
              def printable_method
                @printable_method ||= Commands::GeneratePrintableMethod.call(matcher: self)
              end

              ##
              # @return [String]
              #
              # @internal
              #   NOTE: An example of how RSpec extracts block source, but they marked it as private.
              #   https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
              #
              #   TODO: `printable_block_expectation` when `method_source` is available.
              #   https://github.com/banister/method_source
              #
              #   def printable_block_expectation
              #     @printable_block_expectation ||= block_expectation.source
              #   end
              #
              def printable_block_expectation
                @printable_block_expectation ||= "{ ... }"
              end

              ##
              # @return [String]
              #
              def printable_actual_arguments
                delegations
                  .map { |delegation| Commands::GeneratePrintableArguments.call(arguments: delegation.arguments) }
                  .join(", ")
              end
            end
          end
        end
      end
    end
  end
end
