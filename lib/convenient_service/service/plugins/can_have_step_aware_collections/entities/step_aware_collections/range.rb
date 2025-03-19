# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Range < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] range
              #   @return [Range]
              #
              attr_reader :range

              ##
              # @api private
              #
              # @param range [Range]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(range:, organizer:, propagated_result: nil)
                @range = range
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @return [Proc]
              #
              def default_evaluate_by
                ->(range) { range }
              end

              ##
              # @api private
              #
              # @return [Range]
              #
              def enumerable
                range
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  process_as_range(iteration_block) do |step_aware_iteration_block|
                    range.each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(nil) do
                    range.each
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
