# frozen_string_literal: true

require_relative "delegate_to/commands"
require_relative "delegate_to/entities"
require_relative "delegate_to/errors"

##
# @internal
#   IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
#   https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
module ConvenientService
  module RSpec
    module Matchers
      module Custom
        ##
        # @internal
        #   NOTE: This is a Facade class.
        #   https://refactoring.guru/design-patterns/facade
        #
        class DelegateTo
          include Support::Delegate

          ##
          # @param block_expectation [Proc]
          # @return [Boolean]
          #
          delegate :matches?, to: :matcher

          ##
          # @internal
          #   NOTE: Required by RSpec.
          #   https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-matcher-supporting-block-expectations
          #
          delegate :supports_block_expectations?, to: :matcher

          ##
          # @return [String]
          #
          delegate :description, to: :matcher

          ##
          # @return [String]
          #
          delegate :failure_message, to: :matcher

          ##
          # @return [String]
          #
          delegate :failure_message_when_negated, to: :matcher

          ##
          # @overload initialize(object, method)
          #   @param object [Object]
          #   @param method [String, Symbol]
          #   @return [void]
          #
          # @overload initialize(matcher)
          #   @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
          #   @return [void]
          #   @api private
          #
          # @internal
          #   TODO: `overload do`?
          #
          def initialize(object = nil, method = nil, matcher: nil)
            @matcher = matcher || Entities::Matcher.new(object, method)
          end

          ##
          # @param expected_args [Array]
          # @param expected_kwargs [Hash]
          # @param expected_block [Proc]
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
          #
          def with_arguments(*expected_args, **expected_kwargs, &expected_block)
            matcher.with_arguments(*expected_args, **expected_kwargs, &expected_block)

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ArgumentsChainingIsAlreadySet]
          #
          def without_arguments
            matcher.without_arguments

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Errors::ReturnItsValueChainingIsAlreadySet]
          #
          def and_return_its_value
            matcher.and_return_its_value

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
          #
          def without_calling_original
            matcher.without_calling_original

            self
          end

          private

          ##
          # @!attribute [r] matcher
          #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
          #
          attr_reader :matcher
        end
      end
    end
  end
end
