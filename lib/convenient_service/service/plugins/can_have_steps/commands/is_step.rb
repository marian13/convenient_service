# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Commands
          class IsStep < Support::Command
            ##
            # @!attribute [r] step
            #   @return [Object] Can be any type.
            #
            attr_reader :step

            ##
            # @param step [Object] Can be any type.
            # @return [void]
            #
            def initialize(step:)
              @step = step
            end

            ##
            # @return [Boolean]
            #
            def call
              step.class.include?(Entities::Step::Concern)
            end
          end
        end
      end
    end
  end
end
