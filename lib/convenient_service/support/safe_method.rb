# frozen_string_literal: true

module ConvenientService
  module Support
    class SafeMethod
      ##
      # @!attribute [r] object
      #   @return [Object] Can be any type.
      #
      attr_reader :object

      ##
      # @!attribute [r] method
      #   @return [Symbol, String]
      #
      attr_reader :method

      ##
      # @!attribute [r] default
      #   @return [Object] Can be any type.
      #
      attr_reader :default

      ##
      # @param object [Object] Can be any type.
      # @param method [Symbol, String]
      # @param default [Object, nil] Can be any type.
      # @return [void]
      #
      def initialize(object, method, default: nil)
        @object = object
        @method = method
        @default = default
      end

      ##
      # @param args [Array<Object>]
      # @param kwargs [Hash{Symbol => Object}]
      # @param block [Proc, nil]
      # @return [Object] Can be any type.
      #
      def call(*args, **kwargs, &block)
        return default unless method_defined?

        object.__send__(method, *args, **kwargs, &block)
      end

      private

      ##
      # @return [Boolean]
      #
      def method_defined?
        Utils::Method.defined?(method, klass, private: true)
      end

      ##
      # @return [Class]
      #
      def klass
        @klass ||= Utils::Object.duck_class(object)
      end
    end
  end
end
