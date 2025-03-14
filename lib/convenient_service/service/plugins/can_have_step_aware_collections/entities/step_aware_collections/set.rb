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
              # @api private
              #
              # @return [Set]
              #
              def enumerable
                set
              end
            end
          end
        end
      end
    end
  end
end
