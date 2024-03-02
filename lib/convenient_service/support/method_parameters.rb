# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # Wrapps `Method#parameters` return value to provide a higher level interface.
    #
    # @note `Method#parameters` return value may look like the following.
    #
    #   def foo(a, b = 1, *args, c:, d: 2, **kwargs, &block)
    #   end
    #
    #   method(:foo).parameters
    #   # => [[:req, :a], [:opt, :b], [:rest, :args], [:keyreq, :c], [:key, :d], [:keyrest, :kwargs], [:block, :block]]
    #
    # @see https://ruby-doc.org/core-2.7.1/Method.html#method-i-parameters
    #
    class MethodParameters
      module Constants
        module Types
          REQUIRED_KEYWORD = :keyreq
          OPTIONAL_KEYWORD = :key

          REST_KEYWORDS = :keyrest
        end
      end

      ##
      # @!attribute [r] parameters
      #   @return [Array]
      #
      attr_reader :parameters

      ##
      # @param parameters [Array]
      # @return [void]
      #
      def initialize(parameters)
        @parameters = parameters
      end

      ##
      # Returns `true` when method definition has `**kwargs`.
      # @return [Boolean]
      #
      # @example `rest_kwargs` means NOT named kwargs.
      #
      #   def foo(a, b = 1, *args, c:, d: 2, **kwargs, &block)
      #   end
      #
      #   def bar(a, b = 1, *args, c:, d: 2, &block)
      #   end
      #
      #   ConvenientService::Support::MethodParameters.new(method(:foo).parameters).has_rest_kwargs?
      #   # => true
      #
      #   ConvenientService::Support::MethodParameters.new(method(:bar).parameters).has_rest_kwargs?
      #   # => false
      #
      # @see https://ruby-doc.org/core-2.7.1/Method.html#method-i-parameters
      #
      def has_rest_kwargs?
        return @has_rest_kwargs if defined? @has_rest_kwargs

        @has_rest_kwargs = parameters.any? { |type, _name| type == Constants::Types::REST_KEYWORDS }
      end

      ##
      # @return [Array<Symbol>]
      #
      # @example `named_kwargs_keys` are `kwargs` with or without `defaults`.
      #
      #   def foo(a, b = 1, *args, c:, d: 2, **kwargs, &block)
      #   end
      #
      #   ConvenientService::Support::MethodParameters.new(method(:foo).parameters).named_kwargs_keys
      #   # => [:c, :d]
      #
      # @note `named_kwargs_keys` is an optimized way to get `required_kwargs_keys + optional_kwargs_keys`.
      # @see https://ruby-doc.org/core-2.7.1/Method.html#method-i-parameters
      #
      def named_kwargs_keys
        @named_kwargs_keys ||= parameters.select { |type, _name| type == Constants::Types::REQUIRED_KEYWORD || type == Constants::Types::OPTIONAL_KEYWORD }.map { |_type, name| name }
      end

      ##
      # @return [Array<Symbol>]
      #
      # @note `required_kwargs` are named `kwargs` without `defaults`.
      #
      #   def foo(a, b = 1, *args, c:, d: 2, **kwargs, &block)
      #   end
      #
      #   ConvenientService::Support::MethodParameters.new(method(:foo).parameters).required_kwargs_keys
      #   # => [:c]
      #
      # @see https://ruby-doc.org/core-2.7.1/Method.html#method-i-parameters
      #
      def required_kwargs_keys
        @required_kwargs_keys ||= parameters.select { |type, _name| type == Constants::Types::REQUIRED_KEYWORD }.map { |_type, name| name }
      end

      ##
      # @return [Array<Symbol>]
      #
      # @note `optional_kwargs` are named `kwargs` with `defaults`.
      #
      #   def foo(a, b = 1, *args, c:, d: 2, **kwargs, &block)
      #   end
      #
      #   ConvenientService::Support::MethodParameters.new(method(:foo).parameters).optional_kwargs_keys
      #   # => [:d]
      #
      # @see https://ruby-doc.org/core-2.7.1/Method.html#method-i-parameters
      #
      def optional_kwargs_keys
        @optional_kwargs_keys ||= parameters.select { |type, _name| type == Constants::Types::OPTIONAL_KEYWORD }.map { |_type, name| name }
      end
    end
  end
end
