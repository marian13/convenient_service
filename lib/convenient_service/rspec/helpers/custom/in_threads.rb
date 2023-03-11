# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        # @internal
        #   TODO: Specs.
        #
        class InThreads < Support::Command
          ##
          # @!attribute [r] n
          #   @return [Integer] Amount of threads.
          #
          attr_reader :n

          ##
          # @!attribute [r] args
          #   @return [Array<Object>] Args passed to `Thread.new`.
          #
          # @internal
          #   NOTE: More info about `args`.
          #   - https://ruby-doc.org/core-2.7.0/Thread.html#method-c-new
          #
          attr_reader :args

          ##
          # @!attribute [r] block
          #   @return [Proc] Block passed to `Thread.new`.
          #
          # @internal
          #   NOTE: More info about `block`.
          #   - https://ruby-doc.org/core-2.7.0/Thread.html#method-c-new
          #
          attr_reader :block

          ##
          # @param n [Integer] Amount of threads.
          # @param args [Array<Object>] Args passed to `Thread.new`.
          # @param block [Proc] Block passed to `Thread.new`.
          # @return [void]
          #
          def initialize(n, *args, &block)
            @n = n
            @args = args
            @block = block
          end

          ##
          # @return [Array<Object>] Thread values. Can be any type.
          #
          # @internal
          #   NOTE: `thread.value` calls `thread.join` under the hood. That is why it is missed here.
          #   - https://ruby-doc.org/core-2.7.0/Thread.html#method-i-value
          #
          #   TODO: Thread pool? Why?
          #
          def call
            threads = []

            n.times { threads << ::Thread.new(*args, &block) }

            threads.map(&:value)
          end
        end
      end
    end
  end
end
