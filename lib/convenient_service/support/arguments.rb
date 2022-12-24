# frozen_string_literal: true

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
      # @param args [Array]
      # @param kwargs [Hash]
      # @param block [Proc]
      # @return [void]
      #
      def initialize(*args, **kwargs, &block)
        @args = args
        @kwargs = kwargs
        @block = block
      end

      class << self
        ##
        # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::NullArguments]
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
    end
  end
end
