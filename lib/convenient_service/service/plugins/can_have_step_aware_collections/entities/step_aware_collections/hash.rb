# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Hash < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] hash
              #   @return [Hash]
              #
              attr_reader :hash

              ##
              # @api private
              #
              # @param hash [Hash]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(hash:, organizer:, propagated_result: nil)
                @hash = hash
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @api private
              #
              # @return [Hash]
              #
              def enumerable
                hash
              end
            end
          end
        end
      end
    end
  end
end
