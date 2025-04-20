# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module FiniteLoop
      ##
      # @return [Integer]
      #
      MAX_ITERATION_COUNT = 1_000

      module Exceptions
        class MaxIterationCountExceeded < ::ConvenientService::Exception
          ##
          # @param limit [Integer]
          # @return [void]
          #
          def initialize_with_kwargs(limit:)
            message = <<~TEXT
              Max iteration count is exceeded. Current limit is #{limit}.

              Consider using `max_iteration_count` or `raise_on_exceedance` options if that is not the expected behavior.
            TEXT

            initialize(message)
          end
        end

        class NoBlockGiven < ::ConvenientService::Exception
          ##
          # @return [void]
          #
          def initialize_without_arguments
            message = <<~TEXT
              `finite_loop` always expects a block to be given.
            TEXT

            initialize(message)
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
        ::ConvenientService.raise Exceptions::NoBlockGiven.new unless block

        loop.with_index do |_, index|
          if index >= max_iteration_count
            break default unless raise_on_exceedance

            ::ConvenientService.raise Exceptions::MaxIterationCountExceeded.new(limit: max_iteration_count)
          end

          yield(index)
        end
      end
    end
  end
end
