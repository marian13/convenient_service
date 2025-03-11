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
              # @return [void]
              #
              def initialize(chain_enumerator:, organizer:)
                @chain_enumerator = chain_enumerator
                @organizer = organizer
              end

              ##
              # @api private
              #
              # @return [Enumerator::Chain]
              #
              def enumerable
                chain_enumerator
              end
            end
          end
        end
      end
    end
  end
end
