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
              # @!attribute [r] propagated_result
              #   @return[ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              #
              attr_reader :propagated_result

              ##
              # @api private
              #
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              abstract_method :result

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def success(...)
                organizer.success(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def failure(...)
                organizer.failure(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def error(...)
                organizer.error(...)
              end
            end
          end
        end
      end
    end
  end
end
