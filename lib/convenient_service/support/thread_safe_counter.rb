# frozen_string_literal: true

module ConvenientService
  module Support
    class ThreadSafeCounter
      module Errors
        class MaxValueExceeded < ::StandardError
          def initialize(max_value:)
            message = <<~TEXT
              Max counter value is exceeded. Current limit is #{max_value}.
            TEXT

            super(message)
          end
        end
      end

      def initialize(initial_value: 0, max_value: ::Float::INFINITY)
        @current_value = initial_value
        @max_value = max_value
        @lock = ::Mutex.new
      end

      def increment!
        @lock.synchronize do
          raise Errors::MaxValueExceeded.new(max_value: @max_value) if @current_value > @max_value

          @current_value += 1
        end
      end
    end
  end
end
