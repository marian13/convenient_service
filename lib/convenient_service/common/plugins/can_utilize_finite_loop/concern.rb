# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanUtilizeFiniteLoop
        module Concern
          include Support::Concern

          instance_methods do
            private

            ##
            # @param max_iteration_count [Integer]
            # @param default [Object] Can be any type.
            # @param raise_on_exceedance [Boolean]
            # @param block [Proc]
            # @return [Object] Can be any type.
            #
            def finite_loop(
              max_iteration_count: Constants::MAX_ITERATION_COUNT,
              default: Constants::FINITE_LOOP_EXCEEDED,
              raise_on_exceedance: false,
              &block
            )
              Support::FiniteLoop.finite_loop(max_iteration_count: max_iteration_count, default: default, raise_on_exceedance: raise_on_exceedance, &block)
            end

            ##
            # @return [ConvenientService::Support::UniqueValue]
            #
            def finite_loop_exceeded
              Constants::FINITE_LOOP_EXCEEDED
            end
          end
        end
      end
    end
  end
end
