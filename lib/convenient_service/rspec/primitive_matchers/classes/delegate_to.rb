# frozen_string_literal: true

require_relative "delegate_to/entities"

##
# @internal
#   IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
#   https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
#   TODO: `compare_by`.
#
module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        ##
        # @internal
        #   NOTE: This is a Facade class.
        #   https://refactoring.guru/design-patterns/facade
        #
        class DelegateTo
          include Support::Delegate

          ##
          # @api public
          #
          # @return [Boolean]
          #
          delegate :matches?, to: :matcher

          ##
          # @api public
          #
          # @internal
          #   NOTE: Required by RSpec.
          #   https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-matcher-supporting-block-expectations
          #
          delegate :supports_block_expectations?, to: :matcher

          ##
          # @api public
          #
          # @return [String]
          #
          delegate :description, to: :matcher

          ##
          # @api public
          #
          # @return [String]
          #
          delegate :failure_message, to: :matcher

          ##
          # @api public
          #
          # @return [String]
          #
          delegate :failure_message_when_negated, to: :matcher

          ##
          # @overload initialize(object, method)
          #   @api public
          #
          #   @param object [Object]
          #   @param method [String, Symbol]
          #   @return [void]
          #
          # @overload initialize(matcher)
          #   @api private
          #
          #   @param matcher [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher]
          #   @return [void]
          #   @api private
          #
          # @internal
          #   TODO: `overload do`?
          #   TODO: Raise when object is an immediate value.
          #   TODO: Raise when object already has a stub.
          #   TODO: `and_return`.
          #
          def initialize(object = nil, method = nil, matcher: nil)
            @matcher = matcher || Entities::Matcher.new(object, method)
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def with_arguments(...)
            matcher.with_arguments(...)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def with_any_arguments
            matcher.with_any_arguments

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def without_arguments
            matcher.without_arguments

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ReturnItsValueChainingIsAlreadySet]
          #
          def and_return_its_value
            matcher.and_return_its_value

            self
          end

          ##
          # @api private
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions::ReturnItsValueChainingIsAlreadySet]
          #
          # @internal
          #   NOTE: NOT ready for public usage since it currently reuses `and_return_its_value` failure messages.
          #
          def and_return(...)
            matcher.and_return(...)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          #
          def with_calling_original
            matcher.with_calling_original

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          #
          def without_calling_original
            matcher.without_calling_original

            self
          end

          ##
          # @api private
          #
          # @param comparison_method [Symbo, String]
          # @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo]
          #
          # @internal
          #   NOTE: NOT ready for public usage. Probably requires values chainings removal.
          #
          def comparing_by(...)
            matcher.comparing_by(...)

            self
          end

          private

          ##
          # @!attribute [r] matcher
          #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher]
          #
          attr_reader :matcher
        end
      end
    end
  end
end
