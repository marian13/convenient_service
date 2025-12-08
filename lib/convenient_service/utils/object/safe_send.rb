# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Object
      ##
      # Returns `nil` when `object` does NOT respond to `method`.
      # Otherwise it calls `method` on `object` and returns its value.
      # If calling `method` on `object` raises an exception, it is rescued and `nil` is returned.
      # Only `StandardError` exceptions are rescued.
      # Uses `__send__` under the hood.
      #
      # @note `ArgumentError` is `StandardError` descendant, so it is also rescued. It is up to the client code to ensure that valid arguments are passed.
      # @see https://ruby-doc.org/core-2.7.0/BasicObject.html#method-i-__send__
      # @see https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to-3F
      # @see https://ruby-doc.org/core-2.7.0/StandardError.html
      # @see https://ruby-doc.org/core-2.7.0/ArgumentError.html
      #
      class SafeSend < Support::Command
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
        # @!attribute [r] args
        #   @return [Array<Object>]
        #
        attr_reader :args

        ##
        # @!attribute [r] kwargs
        #   @return [Hash{Symbol => Object}]
        #
        attr_reader :kwargs

        ##
        # @!attribute [r] block
        #   @return [Proc, nil]
        #
        attr_reader :block

        ##
        # @param object [Object] Can be any type.
        # @param method [String, Symbol]
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc, nil]
        #
        def initialize(object, method, *args, **kwargs, &block)
          @object = object
          @method = method
          @args = args
          @kwargs = kwargs
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        # @note `SafeSend` is similar to `JSON::SafeParse` in a sense that it never raises exceptions.
        #
        # @internal
        #   NOTE: `true` in `respond_to?(method, true)` means to look for protected and private methods as well.
        #   - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to-3F
        #
        def call
          return unless object.respond_to?(method, true)

          begin
            object.__send__(method, *args, **kwargs, &block)
          rescue
            nil
          end
        end
      end
    end
  end
end
