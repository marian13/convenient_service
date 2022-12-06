# frozen_string_literal: true

require_relative "delegate_to/commands"
require_relative "delegate_to/entities"

##
# @internal
#   IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
#   https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
#   TODO: Refactor into composition:
#     - Ability to compose when `delegate_to` is used `without_arguments`.
#     - Ability to compose when `delegate_to` is used `with_arguments`.
#     - Ability to compose when `delegate_to` is used `and_return_its_value`.
#
#   TODO: Refactor to NOT use `expect` inside this matcher.
#   This way the matcher will return true or false, but never raise exceptions (descendant of Exception, not StandardError).
#   Then it will be easier to developer a fully comprehensive spec suite for `delegate_to`.
#
module ConvenientService
  module RSpec
    module Matchers
      module Custom
        ##
        # @internal
        #   specify {
        #     expect { method_class.cast(other, **options) }
        #       .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethod, :call)
        #       .with_arguments(other: other, options: options)
        #       .and_return_its_value
        #   }
        #
        #   { method_class.cast(other, **options) }
        #   # => block_expectation
        #
        #   ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethod
        #   # => object
        #
        #   :call
        #   #=> method
        #
        #   (other: other, options: options)
        #   # => chain[:with]
        #
        #   and_return_its_value
        #   # => chain[:and_return_its_value]
        #
        #   NOTE: A similar (with different behaviour) matcher exists in `saharspec`.
        #   https://github.com/zverok/saharspec#send_messageobject-method-matcher
        #
        class DelegateTo
          ##
          # @param object [Object]
          # @param method [String, Symbol]
          # @return [void]
          #
          def initialize(object, method)
            @matcher = Entities::Matcher.new(object: object, method: method)
          end

          ##
          # @param block_expectation [Proc]
          # @return [Boolean]
          #
          def matches?(block_expectation)
            # byebug

            matcher.add_arguments_chaining(Entities::Chainings::WithoutArguments) unless matcher.has_arguments_chaining?

            matcher.matches?(block_expectation)
          end

          ##
          # @internal
          #   NOTE: Required by RSpec.
          #   https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-matcher-supporting-block-expectations
          #
          def supports_block_expectations?
            true
          end

          ##
          # @return [String]
          #
          def description
            matcher.description
          end

          ##
          # @return [String]
          #
          def failure_message
            matcher.failure_message
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            matcher.failure_message_when_negated
          end

          ##
          # @param expected_args [Array]
          # @param expected_kwargs [Hash]
          # @param expected_block [Proc]
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
          #
          def with_arguments(*expected_args, **expected_kwargs, &expected_block)
            matcher.expected_arguments = Entities::Arguments.new(args: expected_args, kwargs: expected_kwargs, block: expected_block)

            matcher.add_arguments_chaining(Entities::Chainings::WithArguments)

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
          #
          def without_arguments
            matcher.add_arguments_chaining(Entities::Chainings::WithoutArguments)

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
          #
          def and_return_its_value
            matcher.add_return_its_value_chaining(Entities::Chainings::ReturnItsValue)

            self
          end

          private

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
          #
          attr_reader :matcher
        end
      end
    end
  end
end
