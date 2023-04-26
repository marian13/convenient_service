# frozen_string_literal: true

module ConvenientService
  module Support
    module FiniteLoop
      ##
      # @return [Integer]
      #
      MAX_ITERATION_COUNT = 1_000

      module Errors
        class MaxIterationCountExceeded < ::ConvenientService::Error
          ##
          # @param limit [Integer]
          # @return [void]
          #
          def initialize(limit:)
            message = <<~TEXT
              Max iteration count is exceeded. Current limit is #{limit}.

              Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
            TEXT

            super(message)
          end
        end

        class NoBlockGiven < ::ConvenientService::Error
          ##
          # @return [void]
          #
          def initialize
            message = <<~TEXT
              `finite_loop` always expects a block to be given.
            TEXT

            super(message)
          end
        end
      end

      private

      ##
      # @example Provides `self.finite_loop` in order to have a way to use `finite_loop` without including `ConvenientService::Support::FiniteLoop`.
      #   ConvenientService::Support::FiniteLoop.finite_loop do |index|
      #     break if index > 3
      #   end
      #
      module_function

      ##
      # @param max_iteration_count [Integer]
      # @param raise_on_exceedance [Boolean]
      # @param block [Proc, nil]
      # @return [Object] Can be any type.
      #
      # @example
      #   class Person
      #     include ConvenientService::Support::FiniteLoop
      #
      #     def foo
      #       finite_loop do |index|
      #         break if index > 3
      #       end
      #     end
      #   end
      #
      def finite_loop(default: nil, max_iteration_count: MAX_ITERATION_COUNT, raise_on_exceedance: true, &block)
        raise Errors::NoBlockGiven.new unless block

        loop.with_index do |_, index|
          if index >= max_iteration_count
            break default unless raise_on_exceedance

            raise Errors::MaxIterationCountExceeded.new(limit: max_iteration_count)
          end

          block.call(index)
        end
      end
    end
  end
end
