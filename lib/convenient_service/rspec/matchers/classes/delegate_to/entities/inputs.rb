# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            class Inputs
              ##
              # @api private
              #
              # @!attribute [r] values
              #   @return [Hash{Symbol => Object}]
              #
              attr_reader :values

              ##
              # @api private
              #
              # @param object [Object]
              # @param method [String, Symbol]
              # @param block_expectation [Proc]
              # @return [void]
              #
              def initialize(object:, method:, block_expectation:)
                @values = {object: object, method: method, block_expectation: block_expectation}
              end

              ##
              # @api private
              #
              # @return [Proc, nil]
              #
              def block_expectation
                values[:block_expectation]
              end

              ##
              # @api private
              #
              # @return [Object] Can be any type.
              #
              # @internal
              #   IMPORTANT: Must be refreshed when `expected_arguments` are reset.
              #
              def custom_return_value
                return values[:custom_return_value] if values.has_key?(:custom_return_value)

                values[:custom_return_value] = expected_return_value_block.call(delegation_value)
              end

              ##
              # @api private
              #
              # @return [Object] Can be any type.
              #
              # @internal
              #   IMPORTANT: Must be refreshed when `expected_arguments` are reset.
              #
              def delegation_value
                return values[:delegation_value] if values.has_key?(:delegation_value)

                values[:delegation_value] = object.__send__(method, *expected_arguments.args, **expected_arguments.kwargs, &expected_arguments.block)
              end

              ##
              # @api private
              #
              # @return [ConvenientService::Support::Arguments]
              #
              def expected_arguments
                values[:expected_arguments] ||= Support::Arguments.null_arguments
              end

              ##
              # @api private
              #
              # @return [Proc]
              #
              def expected_return_value_block
                values[:expected_return_value_block] ||= proc { Support::UNDEFINED }
              end

              ##
              # @api private
              #
              # @return [String, Symbol]
              #
              def method
                values[:method]
              end

              ##
              # @api private
              #
              # @return [Object] Can be any type.
              #
              def object
                values[:object]
              end

              ##
              # @api private
              #
              # @return [String]
              #
              def printable_block_expectation
                @printable_block_expectation ||= Utils::Proc.display(block_expectation)
              end

              ##
              # @api private
              #
              # @return [String]
              #
              def printable_method
                @printable_method ||= Commands::GeneratePrintableMethod.call(object: object, method: method)
              end

              ##
              # @api private
              #
              # @return [Boolean]
              #
              def has_call_original?
                values.has_key?(:should_call_original)
              end

              ##
              # @api private
              #
              # @return [Boolean]
              #
              def should_call_original?
                return values[:should_call_original] if values.has_key?(:should_call_original)

                values[:should_call_original] = true
              end

              ##
              # @api private
              #
              # @return [Proc]
              #
              def block_expectation=(block)
                values[:block_expectation] = block
              end

              ##
              # @api private
              #
              # @param arguments [ConvenientService::Support::Arguments]
              # @return [ConvenientService::Support::Arguments]
              #
              def expected_arguments=(arguments)
                values.delete(:delegation_value)
                values.delete(:custom_return_value)

                values[:expected_arguments] = arguments
              end

              ##
              # @api private
              #
              # @param flag [Boolean]
              # @return [Boolean]
              #
              def should_call_original=(flag)
                values[:should_call_original] = flag
              end

              ##
              # @api private
              #
              # @param block [Proc]
              # @return [Proc]
              # @raise [ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions::ReturnCustomValueChainingInvalidArguments]
              #
              def update_expected_return_value_block(*args, &block)
                values.delete(:custom_return_value)

                values[:expected_return_value_block] =
                  if args.any? && block
                    ::ConvenientService.raise Exceptions::ReturnCustomValueChainingInvalidArguments.new
                  elsif args.any?
                    proc { args.first }
                  elsif block
                    block
                  else
                    ::ConvenientService.raise Exceptions::ReturnCustomValueChainingInvalidArguments.new
                  end
              end

              ##
              # @api private
              #
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              # @internal
              #   TODO: Unify `==(other)` YARD tags.
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if values != other.values

                true
              end
            end
          end
        end
      end
    end
  end
end

require_relative "inputs/jruby"
