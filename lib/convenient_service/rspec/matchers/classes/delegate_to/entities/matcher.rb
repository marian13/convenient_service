# frozen_string_literal: true

require_relative "matcher/commands"
require_relative "matcher/entities"

##
# @internal
#   IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
#   https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
module ConvenientService
  module RSpec
    module Matchers
      module Classes
        ##
        # @internal
        #   specify {
        #     expect { method_class.cast(other, **options) }
        #       .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod, :call)
        #       .with_arguments(other: other, options: options)
        #       .and_return_its_value
        #   }
        #
        #   { method_class.cast(other, **options) }
        #   # => block_expectation
        #
        #   ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod
        #   # => object
        #
        #   :call
        #   #=> method
        #
        #   (other: other, options: options)
        #   # => expected_arguments
        #
        #   and_return_its_value
        #   # => return_its_value_chaining
        #
        #   NOTE: A similar (with different behaviour) matcher exists in `saharspec`.
        #   https://github.com/zverok/saharspec#send_messageobject-method-matcher
        #
        class DelegateTo
          module Entities
            class Matcher
              include Support::Delegate

              ##
              # @!attribute [r] object
              #   @return [Object] Can be any type.
              #
              attr_reader :object

              ##
              # @!attribute [r] method
              #   @return [String, Symbol]
              #
              attr_reader :method

              ##
              # @!attribute [r] block_expectation
              #   @return [Proc]
              #
              attr_reader :block_expectation

              ##
              # @return [Boolean]
              #
              delegate :should_call_original?, to: :chainings

              ##
              # @param object [Object]
              # @param method [String, Symbol]
              # @param block_expectation [Proc]
              # @return [void]
              #
              def initialize(object, method, block_expectation = nil)
                ##
                # TODO: `raise unless object.respond_to?(method)`.
                # TODO: `any_block`.
                # TODO: `with_warmup`.
                #
                @object = object
                @method = method
                @block_expectation = block_expectation
              end

              ##
              # @param block_expectation [Proc]
              # @return [Boolean]
              #
              def matches?(block_expectation)
                @block_expectation = block_expectation

                chainings.arguments = Entities::Chainings::SubMatchers::WithAnyArguments.new(matcher: self) unless chainings.has_arguments?
                chainings.call_original = Entities::Chainings::Values::WithCallingOriginal.new(matcher: self) unless chainings.has_call_original?

                chainings.sub_matchers_match?(block_expectation)
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
                "delegate to `#{printable_method}`"
              end

              ##
              # @return [String]
              #
              def failure_message
                chainings.failure_message
              end

              ##
              # @return [String]
              #
              def failure_message_when_negated
                chainings.failure_message_when_negated
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
              #
              def with_arguments(...)
                self.expected_arguments = Support::Arguments.new(...)

                chainings.arguments = Entities::Chainings::SubMatchers::WithConcreteArguments.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
              #
              def with_any_arguments
                chainings.arguments = Entities::Chainings::SubMatchers::WithAnyArguments.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
              #
              def without_arguments
                chainings.arguments = Entities::Chainings::SubMatchers::WithoutArguments.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnItsValueChainingIsAlreadySet]
              #
              def and_return_its_value
                chainings.return_its_value = Entities::Chainings::SubMatchers::ReturnItsValue.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              #
              def with_calling_original
                chainings.call_original = Entities::Chainings::Values::WithCallingOriginal.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
              #
              def without_calling_original
                chainings.call_original = Entities::Chainings::Values::WithoutCallingOriginal.new(matcher: self)

                self
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def expected_arguments
                @expected_arguments ||= Support::Arguments.null_arguments
              end

              ##
              # @param arguments [ConvenientService::Support::Arguments]
              # @return [ConvenientService::Support::Arguments]
              #
              def expected_arguments=(arguments)
                Utils::Object.instance_variable_delete(self, :@delegation_value)

                @expected_arguments = arguments
              end

              ##
              # @return [Object] Can be any type.
              #
              # @internal
              #   IMPORTANT: Must be refreshed when `expected_arguments` are reset.
              #
              def delegation_value
                Utils::Object.memoize_including_falsy_values(self, :@delegation_value) do
                  object.__send__(
                    method,
                    *expected_arguments.args,
                    **expected_arguments.kwargs,
                    &expected_arguments.block
                  )
                end
              end

              ##
              # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings]
              # @api private
              #
              def chainings
                @chainings ||= Entities::ChainingsCollection.new(matcher: self)
              end

              ##
              # @return [Array]
              # @api private
              #
              def delegations
                @delegations ||= []
              end

              ##
              # @return [String]
              #
              def printable_method
                @printable_method ||= Commands::GeneratePrintableMethod.call(object: object, method: method)
              end

              ##
              # @return [String]
              #
              def printable_block_expectation
                @printable_block_expectation ||= Utils::Proc.display(block_expectation)
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              # @internal
              #   TODO: Unify ==(other) YARD tags.
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if object != other.object
                return false if method != other.method
                return false if block_expectation != other.block_expectation

                true
              end
            end
          end
        end
      end
    end
  end
end
