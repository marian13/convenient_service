# frozen_string_literal: true

module ConvenientService
  module Support
    class ThreadSafeCounter
      module Errors
        class ValueAfterIncrementIsGreaterThanMaxValue < ::StandardError
          ##
          # @param n [Integer]
          # @param current_value [Integer]
          # @param max_value [Integer]
          # @return [void]
          #
          def initialize(n:, current_value:, max_value:)
            message = <<~TEXT
              Value after increment by `#{n}` is greater than the max value.

              Current value is `#{current_value}`.

              Max value is `#{max_value}`.
            TEXT

            super(message)
          end
        end

        class ValueAfterDecrementIsLowerThanMinValue < ::StandardError
          ##
          # @param n [Integer]
          # @param current_value [Integer]
          # @param min_value [Integer]
          # @return [void]
          #
          def initialize(n:, current_value:, min_value:)
            message = <<~TEXT
              Value after decrement by `#{n}` is lower than the min value.

              Current value is `#{current_value}`.

              Min value is `#{min_value}`.
            TEXT

            super(message)
          end
        end
      end

      ##
      # @!attribute [r] initial_value
      #   @return [Integer]
      #
      attr_reader :initial_value

      ##
      # @!attribute [r] current_value
      #   @return [Integer]
      #
      attr_reader :current_value

      ##
      # @!attribute [r] min_value
      #   @return [Integer, Float::INFINITY]
      #
      attr_reader :min_value

      ##
      # @!attribute [r] max_value
      #   @return [Integer, Float::INFINITY]
      #
      attr_reader :max_value

      ##
      # @param initial_value [Integer]
      # @param min_value [Integer, -::Float::Infinity]
      # @param max_value [Integer, Float::Infinity]
      # @return [void]
      #
      # @note Do NOT rely on the fact that `min_value` and `max_value` are almost always `Integer` instances since they are set to `-Float::INFINITY` and `Float::INFINITY` by default.
      # @note `Float::INFINITY` and `Integer` are just contextual ducks, NOT full ducks. For example, `Float::INFINITY.to_i` raises `FloatDomainError`.
      #
      # @internal
      #   NOTE: Mutex and Semaphore docs.
      #   - https://ruby-doc.org/core-2.7.0/Mutex.html
      #   - https://en.wikipedia.org/wiki/Semaphore_(programming)
      #
      def initialize(initial_value: 0, min_value: -::Float::INFINITY, max_value: ::Float::INFINITY)
        @initial_value = initial_value
        @current_value = initial_value
        @min_value = min_value
        @max_value = max_value
        @lock = ::Mutex.new
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def increment(n = 1)
        @lock.synchronize do
          break @current_value if @current_value + n > @max_value

          @current_value += n
        end
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      # @raise [ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def increment!(n = 1)
        @lock.synchronize do
          raise Errors::ValueAfterIncrementIsGreaterThanMaxValue.new(n: n, current_value: @current_value, max_value: @max_value) if @current_value + n > @max_value

          @current_value += n
        end
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def decrement(n = 1)
        @lock.synchronize do
          break @current_value if @current_value - n < @min_value

          @current_value -= n
        end
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      # @raise [ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def decrement!(n = 1)
        @lock.synchronize do
          raise Errors::ValueAfterDecrementIsLowerThanMinValue.new(n: n, current_value: @current_value, min_value: @min_value) if @current_value - n < @min_value

          @current_value -= n
        end
      end

      ##
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def reset
        @lock.synchronize { @current_value = @initial_value }
      end
    end
  end
end
