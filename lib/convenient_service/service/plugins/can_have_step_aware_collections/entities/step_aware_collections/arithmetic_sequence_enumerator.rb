# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class ArithmeticSequenceEnumerator < Entities::StepAwareCollections::Enumerator
              ##
              # @api private
              #
              # @!attribute [r] arithmetic_sequence_enumerator
              #   @return [Enumerator::ArithmeticSequence]
              #
              attr_reader :arithmetic_sequence_enumerator

              ##
              # @api private
              #
              # @param arithmetic_sequence_enumerator [Enumerator::ArithmeticSequence]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(arithmetic_sequence_enumerator:, organizer:, propagated_result: nil)
                @arithmetic_sequence_enumerator = arithmetic_sequence_enumerator
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @return [Proc]
              #
              def default_evaluate_by
                ->(arithmetic_sequence_enumerator) { arithmetic_sequence_enumerator }
              end

              ##
              # @api private
              #
              # @return [Enumerator::ArithmeticSequence]
              #
              def enumerable
                arithmetic_sequence_enumerator
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ArithmeticSequenceEnumerator]
              #
              def each(&iteration_block)
                process_as_arithmetic_sequence_enumerator(iteration_block) do |step_aware_iteration_block|
                  arithmetic_sequence_enumerator.each(&step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Array, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def first(n = nil)
                if n
                  process_as_array(n, nil) do |n|
                    arithmetic_sequence_enumerator.first(n)
                  end
                else
                  process_as_object_or_nil(nil) do
                    arithmetic_sequence_enumerator.first
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
