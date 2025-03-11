# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Enumerator < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] enumerator
              #   @return [Enumerator]
              #
              attr_reader :enumerator

              ##
              # @api private
              #
              # @param enumerator [Enumerator]
              # @param organizer [ConvenientService::Service]
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(enumerator:, organizer:, result: nil)
                @enumerator = enumerator
                @organizer = organizer
                @result = result
              end

              ##
              # @api private
              #
              # @return [Enumerator]
              #
              def enumerable
                enumerator
              end
            end
          end
        end
      end
    end
  end
end
