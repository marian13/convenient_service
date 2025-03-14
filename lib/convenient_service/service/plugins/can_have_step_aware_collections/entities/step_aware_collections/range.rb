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
              # @api private
              #
              # @return [Range]
              #
              def enumerable
                range
              end
            end
          end
        end
      end
    end
  end
end
