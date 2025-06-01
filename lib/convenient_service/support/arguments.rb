# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "arguments/exceptions"
require_relative "arguments/null_arguments"

module ConvenientService
  module Support
    class Arguments
      ##
      # @!attribute [r] args
      #   @return [Array]
      #
      attr_reader :args

      ##
      # @!attribute [r] kwargs
      #   @return [Hash]
      #
      attr_reader :kwargs

      ##
      # @!attribute [r] block
      #   @return [Proc]
      #
      attr_reader :block

      ##
      # @param args [Array<Object>]
      # @param kwargs [Hash{Symbol => Object}]
      # @param block [Proc, nil]
      # @return [void]
      #
      def initialize(*args, **kwargs, &block)
        @args = args
        @kwargs = kwargs
        @block = block
      end

      class << self
        ##
        # @return [ConvenientService::Support::Arguments::NullArguments]
        #
        def null_arguments
          @null_arguments ||= Support::Arguments::NullArguments.new
        end
      end

      ##
      # @return [Boolean]
      #
      def null_arguments?
        false
      end

      ##
      # @return [Booleam]
      #
      def any?
        return true if args.any?
        return true if kwargs.any?
        return true if block

        false
      end

      ##
      # @return [Booleam]
      #
      def none?
        !any?
      end

      ##
      # @param key [Integer, Symbol]
      # @return [Object] Can be any type.
      #
      # @internal
      #   NOTE: `[]=` is NOT implemented, since it is NOT logical for `null_arguments`.
      #
      def [](key)
        case key
        when Integer then args[key]
        when Symbol then kwargs[key]
        else ::ConvenientService.raise Exceptions::InvalidKeyType.new(key: key)
        end
      end

      ##
      # @param other [Object]
      # @return [Boolean]
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        return false if args != other.args
        return false if kwargs != other.kwargs
        return false if block != other.block

        true
      end

      ##
      # @api public
      # @return [Array]
      # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
      # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
      # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
      #
      def deconstruct
        [args, kwargs, block]
      end

      ##
      # @api public
      # @param keys [Array<Symbol>, nil]
      # @return [Hash]
      # @note https://zverok.space/blog/2022-12-20-pattern-matching.html
      # @note https://ruby-doc.org/core-2.7.2/doc/syntax/pattern_matching_rdoc.html
      # @note Expected to be called only from pattern matching. Avoid direct usage of this method.
      #
      def deconstruct_keys(keys)
        keys ||= [:args, :kwargs, :block]

        keys.each_with_object({}) do |key, hash|
          case key
          when :args
            hash[key] = args
          when :kwargs
            hash[key] = kwargs
          when :block
            hash[key] = block
          end
        end
      end
    end
  end
end
