# frozen_string_literal: true

module ConvenientService
  module Support
    module FiniteLoop
      MAX_ITERATION_COUNT = 100

      module Errors
        class MaxIterationCountExceeded < ::StandardError
          def initialize(limit:)
            message = <<~TEXT
              Max iteration count is exceeded. Current limit is #{limit}.

              Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
            TEXT

            super(message)
          end
        end

        class NoBlockGiven < ::StandardError
          def initialize
            message = <<~TEXT
              `finite_loop` always expects a block to be given.
            TEXT

            super(message)
          end
        end
      end

      private

      def finite_loop(max_iteration_count: MAX_ITERATION_COUNT, raise_on_exceedance: true, &block)
        raise Errors::NoBlockGiven.new unless block

        loop.with_index do |_, index|
          if index >= max_iteration_count
            break unless raise_on_exceedance

            raise Errors::MaxIterationCountExceeded.new(limit: max_iteration_count)
          end

          block.call(index)
        end
      end
    end
  end
end
