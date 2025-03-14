# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Array < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] array
              #   @return [Array]
              #
              attr_reader :array

              ##
              # @api private
              #
              # @param array [Array]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(array:, organizer:, propagated_result: nil)
                @array = array
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @api private
              #
              # @return [Array]
              #
              def enumerable
                array
              end
            end
          end
        end
      end
    end
  end
end
