# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Set < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] set
              #   @return [Set]
              #
              attr_reader :set

              ##
              # @api private
              #
              # @param set [Set]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(set:, organizer:, propagated_result: nil)
                @set = set
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @return [Proc]
              #
              def default_evaluate_by
                ->(set) { set }
              end

              ##
              # @api private
              #
              # @return [Set]
              #
              def enumerable
                set
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  process_as_set(iteration_block) do |step_aware_iteration_block|
                    set.each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(nil) do
                    set.each
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
