# frozen_string_literal: true

##
# WIP: Factory API is NOT well-thought yet. It will be revisited and completely refactored at any time.
#
module ConvenientService
  module Factories
    module Arguments
      ##
      # @return [Array]
      #
      # @example Default.
      #
      #   hello(*args)
      #
      def create_args
        [:foo, :bar]
      end

      ##
      # @return [Hash]
      #
      # @example Default.
      #
      #   hello(**kwargs)
      #
      def create_kwargs
        {foo: :bar, baz: :qux}
      end

      ##
      # @return [Hash]
      #
      # @example Default.
      #
      #   hello(&block)
      #
      def create_block
        proc { :foo }
      end
    end
  end
end
