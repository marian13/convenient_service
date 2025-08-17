# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "delegate_to/commands"
require_relative "delegate_to/entities"
require_relative "delegate_to/exceptions"

##
# @internal
#   IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
#   - https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
module ConvenientService
  module RSpec
    module Matchers
      module Classes
        ##
        # @internal
        #   NOTE: Consider the following concrete usage example to simplify understanding of variable namings used throughout this class:
        #     specify do
        #       expect { method_class.cast(other, **options) }
        #         .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod, :call)
        #         .with_arguments(other: other, options: options)
        #         .and_return_its_value
        #     end
        #
        #   Block `{ method_class.cast(other, **options) }` is named as `block_expectation`.
        #   Class `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod` is named as `object`.
        #   Symbol `:call` is named as `method`.
        #   Arguments `(other: other, options: options)` are named as `expected_arguments`.
        #   Additional submatcher added by `and_return_its_value` chaining is named as `sub_matchers.return_its_value`.
        #
        #   NOTE: A similar (with different behaviour) matcher exists in `saharspec`.
        #   - https://github.com/zverok/saharspec#send_messageobject-method-matcher
        #
        class DelegateTo
          ##
          # @api private
          #
          # @!attribute [r] inputs
          #   @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Inputs]
          #
          attr_reader :inputs

          ##
          # @api private
          #
          # @!attribute [r] outputs
          #   @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Outputs]
          #
          attr_reader :outputs

          ##
          # @api private
          #
          # @param object [Object]
          # @param method [String, Symbol]
          # @param block_expectation [Proc]
          # @return [void]
          #
          # @internal
          #   TODO: `raise unless object.respond_to?(method)`.
          #   TODO: `any_block`.
          #   TODO: `with_warmup`.
          #   TODO: `compare_by`.
          #
          def initialize(object, method, block_expectation = proc { Support::UNDEFINED })
            @inputs = Entities::Inputs.new(object: object, method: method, block_expectation: block_expectation)
            @outputs = Entities::Outputs.new
          end

          ##
          # @api public
          #
          # @param block_expectation [Proc]
          # @return [Boolean]
          #
          def matches?(block_expectation)
            inputs.block_expectation = block_expectation

            sub_matchers.matches?(inputs.block_expectation)
          end

          ##
          # @api public
          #
          # @param block_expectation [Proc]
          # @return [Boolean]
          #
          def does_not_match?(block_expectation)
            inputs.block_expectation = block_expectation

            !sub_matchers.matches?(inputs.block_expectation)
          end

          ##
          # @api public
          #
          # @internal
          #   NOTE: Required by RSpec.
          #   - https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-matcher-supporting-block-expectations
          #
          def supports_block_expectations?
            true
          end

          ##
          # @api public
          #
          # @return [String]
          #
          def description
            "delegate to `#{inputs.printable_method}`"
          end

          ##
          # @api public
          #
          # @return [String]
          #
          def failure_message
            sub_matchers.failure_message
          end

          ##
          # @api public
          #
          # @return [String]
          #
          def failure_message_when_negated
            sub_matchers.failure_message_when_negated
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def with_arguments(...)
            ::ConvenientService.raise Exceptions::ArgumentsChainingIsAlreadySet.new if sub_matchers.has_arguments?

            inputs.expected_arguments = Support::Arguments.new(...)

            sub_matchers.arguments = Entities::SubMatchers::WithConcreteArguments.new(matcher: self)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def with_any_arguments
            ::ConvenientService.raise Exceptions::ArgumentsChainingIsAlreadySet.new if sub_matchers.has_arguments?

            sub_matchers.arguments = Entities::SubMatchers::WithAnyArguments.new(matcher: self)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ArgumentsChainingIsAlreadySet]
          #
          def without_arguments
            ::ConvenientService.raise Exceptions::ArgumentsChainingIsAlreadySet.new if sub_matchers.has_arguments?

            sub_matchers.arguments = Entities::SubMatchers::WithoutArguments.new(matcher: self)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnValueChainingIsAlreadySet]
          #
          def and_return_its_value
            ::ConvenientService.raise Exceptions::ReturnValueChainingIsAlreadySet.new if sub_matchers.has_return_value?

            sub_matchers.return_value = Entities::SubMatchers::ReturnDelegationValue.new(matcher: self)

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnValueChainingIsAlreadySet]
          #
          def and_return(...)
            ::ConvenientService.raise Exceptions::ReturnValueChainingIsAlreadySet.new if sub_matchers.has_return_value?

            inputs.update_expected_return_value_block(...)

            sub_matchers.return_value = Entities::SubMatchers::ReturnCustomValue.new(matcher: self)

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          #
          def with_calling_original
            ::ConvenientService.raise Exceptions::CallOriginalChainingIsAlreadySet.new if inputs.has_call_original?

            inputs.should_call_original = true

            self
          end

          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
          #
          def without_calling_original
            ::ConvenientService.raise Exceptions::CallOriginalChainingIsAlreadySet.new if inputs.has_call_original?

            inputs.should_call_original = false

            self
          end

          ##
          # @api private
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::SubMatchers]
          #
          def sub_matchers
            @sub_matchers ||= Entities::SubMatcherCollection.new(matcher: self)
          end

          ##
          # @api private
          #
          # @param other [Object] Can be any type.
          # @return [Boolean, nil]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if inputs != other.inputs
            return false if outputs != other.outputs

            true
          end
        end
      end
    end
  end
end
