# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # @internal
    #   NOTE: `return` exits from the enclosing method. `break` from the iterator method. `next` from the block.
    #   - https://github.com/ruby/spec/blob/master/language/return_spec.rb
    #   - https://github.com/ruby/spec/blob/master/language/break_spec.rb
    #   - https://github.com/ruby/spec/blob/master/language/next_spec.rb
    #   - https://stackoverflow.com/a/1402764/12201472
    #
    class Counter
      module Errors
        class ValueAfterIncrementIsGreaterThanMaxValue < ::ConvenientService::Error
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

        class ValueAfterDecrementIsLowerThanMinValue < ::ConvenientService::Error
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
      # @!attribute [rw] current_value
      #   @return [Integer]
      #
      attr_accessor :current_value

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
      #   NOTE: The name is inspired by Redis and Concurrent Ruby.
      #   - https://redis.io/commands/incr/
      #   - https://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/AtomicFixnum.html#increment-instance_method
      #
      def increment(n = 1)
        return @current_value if @current_value + n > @max_value

        @current_value += n
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      # @raise [ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   NOTE: The name is inspired by Rails.
      #   - https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save
      #   - https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21
      #
      def increment!(n = 1)
        raise Errors::ValueAfterIncrementIsGreaterThanMaxValue.new(n: n, current_value: @current_value, max_value: @max_value) if @current_value + n > @max_value

        @current_value += n
      end

      ##
      # `bincrement` means boolean increment. Works exactly in the same way as `increment` except returns a boolean value.
      # If incremented successfully then returns `true`, otherwise - returns `false`.
      #
      # @param n [Integer]
      # @return [Boolean]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def bincrement(n = 1)
        return false if @current_value + n > @max_value

        @current_value += n

        true
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   NOTE: The name is inspired by Redis and Concurrent Ruby.
      #   - https://redis.io/commands/decr/
      #   - https://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/AtomicFixnum.html#decrement-instance_method
      #
      def decrement(n = 1)
        return @current_value if @current_value - n < @min_value

        @current_value -= n
      end

      ##
      # @param n [Integer]
      # @return [Integer]
      # @raise [ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   NOTE: The name is inspired by Rails.
      #   - https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save
      #   - https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21
      #
      def decrement!(n = 1)
        raise Errors::ValueAfterDecrementIsLowerThanMinValue.new(n: n, current_value: @current_value, min_value: @min_value) if @current_value - n < @min_value

        @current_value -= n
      end

      ##
      # `bdecrement` means boolean decrement. Works exactly in the same way as `decrement` except returns a boolean value.
      # If decremented successfully then returns `true`, otherwise - returns `false`.
      #
      # @param n [Integer]
      # @return [Boolean]
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def bdecrement(n = 1)
        return false if @current_value - n < @min_value

        @current_value -= n

        true
      end

      ##
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def reset
        @current_value = @initial_value
      end
    end
  end
end
