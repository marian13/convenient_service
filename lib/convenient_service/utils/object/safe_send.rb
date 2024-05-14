# frozen_string_literal: true

module ConvenientService
  module Utils
    module Object
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
        # @internal
        #   NOTE: `true` in `respond_to?(method, true)` means to look for protected and private methods as well.
        #   - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to-3F
        #
        def call
          return unless object.respond_to?(method, true)

          object.__send__(method, *args, **kwargs, &block)
        end
      end
    end
  end
end
