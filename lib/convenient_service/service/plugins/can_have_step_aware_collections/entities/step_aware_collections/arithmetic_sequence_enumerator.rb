# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class ArithmeticSequenceEnumerator < Entities::StepAwareCollections::Enumerable
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
              # @api private
              #
              # @return [Enumerator::ArithmeticSequence]
              #
              def enumerable
                arithmetic_sequence_enumerator
              end
            end
          end
        end
      end
    end
  end
end
