# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Base
              include Support::AbstractMethod

              ##
              # @api private
              #
              # @!attribute [r] organizer
              #   @return [ConvenientService::Service]
              #
              attr_reader :organizer

              ##
              # @api private
              #
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              abstract_method :result
            end
          end
        end
      end
    end
  end
end
