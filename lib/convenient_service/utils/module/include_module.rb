# frozen_string_literal: true

module ConvenientService
  module Utils
    module Module
      class IncludeModule < Support::Command
        ##
        # @!attribute [r] mod
        #   @return [Module]
        #
        attr_reader :mod

        ##
        # @!attribute [r] other_mod
        #   @return [Module]
        #
        attr_reader :other_mod

        ##
        # @param mod [Module]
        # @param other_mod [Module]
        # @return [void]
        #
        def initialize(mod, other_mod)
          @mod = mod
          @other_mod = other_mod
        end

        ##
        # @return [Boolean]
        #
        def call
          mod.ancestors.drop_while { |ancestor| ancestor != mod }.include?(other_mod)
        end
      end
    end
  end
end
