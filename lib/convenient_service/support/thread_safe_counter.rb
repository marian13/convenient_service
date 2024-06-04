# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # @internal
    #   NOTE: Mutex and Semaphore docs.
    #   - https://ruby-doc.org/core-2.7.0/Mutex.html
    #   - https://en.wikipedia.org/wiki/Semaphore_(programming)
    #
    class ThreadSafeCounter < Support::Counter
      ##
      # @return [void]
      #
      def initialize(...)
        super

        @lock = ::Mutex.new
      end

      ##
      # @see ConvenientService::Support::Counter#current_value=
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def current_value=(...)
        @lock.synchronize { super }
      end

      ##
      # @see ConvenientService::Support::Counter#increment
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def increment(...)
        @lock.synchronize { super }
      end

      ##
      # @see ConvenientService::Support::Counter#increment!
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def increment!(...)
        @lock.synchronize { super }
      end

      ##
      # `bincrement` means boolean increment. Works exactly in the same way as `increment` except returns a boolean value.
      # If incremented successfully then returns `true`, otherwise - returns `false`.
      #
      # @see ConvenientService::Support::Counter#bincrement
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def bincrement(...)
        @lock.synchronize { super }
      end

      ##
      # @see ConvenientService::Support::Counter#decrement
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def decrement(...)
        @lock.synchronize { super }
      end

      ##
      # @see ConvenientService::Support::Counter#decrement!
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def decrement!(...)
        @lock.synchronize { super }
      end

      ##
      # `bdecrement` means boolean decrement. Works exactly in the same way as `decrement` except returns a boolean value.
      # If decremented successfully then returns `true`, otherwise - returns `false`.
      #
      # @see ConvenientService::Support::Counter#bdecrement
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      #   IMPORTANT: The lock is always properly released since it uses ensure under the hood.
      #   - https://github.com/ruby/ruby/blob/v2_7_0/thread_sync.c#L525
      #
      def bdecrement(...)
        @lock.synchronize { super }
      end

      ##
      # @see ConvenientService::Support::Counter#reset
      #
      # @internal
      #   NOTE: Instance variables are accessed directly to release the lock faster.
      #
      def reset(...)
        @lock.synchronize { super }
      end
    end
  end
end
