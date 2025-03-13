# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class ChainEnumerator < Entities::StepAwareCollections::Enumerator
              ##
              # @api private
              #
              # @!attribute [r] chain_enumerator
              #   @return [Enumerator::Chain]
              #
              attr_reader :chain_enumerator

              ##
              # @api private
              #
              # @param chain_enumerator [Enumerator::Chain]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(chain_enumerator:, organizer:, propagated_result: nil)
                @chain_enumerator = chain_enumerator
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @api private
              #
              # @return [Enumerator::Chain]
              #
              def enumerable
                chain_enumerator
              end

              ##
              # @api private
              #
              # @return [Enumerator::Chain]
              #
              def enumerator
                chain_enumerator
              end
            end
          end
        end
      end
    end
  end
end
