# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Delegation
              ##
              # @api private
              #
              # @!attribute [r] arguments
              #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Delegation]
              #
              attr_reader :arguments

              ##
              # @api private
              #
              # @!attribute [r] method
              #   @return [Symbol]
              #
              attr_reader :method

              ##
              # @api private
              #
              # @!attribute [r] object
              #   @return [Object] Can be any type.
              #
              attr_reader :object

              ##
              # @api private
              #
              # @param object [Object] Can be any type.
              # @param method [Symbol]
              # @param args [Array<Object>]
              # @param kwargs [Hash{Symbol => Object}]
              # @param block [Proc, nil]
              # @return [void]
              #
              def initialize(object:, method:, args:, kwargs:, block:)
                @object = object
                @method = method
                @arguments = Support::Arguments.new(*args, **kwargs, &block)
              end

              ##
              # @api private
              #
              # @return [Booleam]
              #
              def with_arguments?
                arguments.any?
              end

              ##
              # @api private
              #
              # @return [Boolean]
              #
              def without_arguments?
                !with_arguments?
              end

              ##
              # @api private
              #
              # @param other [Object]
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if object != other.object
                return false if method != other.method
                return false if arguments != other.arguments

                true
              end
            end
          end
        end
      end
    end
  end
end
