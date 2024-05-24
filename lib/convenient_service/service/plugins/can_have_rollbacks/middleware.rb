# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveRollbacks
        ##
        # @api private
        #
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            result = chain.next(...)

            rollback_result(result) if result.status.unsafe_not_success?

            result
          end

          private

          ##
          # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          # @return [void]
          #
          def rollback_result(result)
            result.from_step? ? rollback_organizer(result.service) : rollback_service(result.service)
          end

          ##
          # Calls service own rollback.
          #
          # @param service [ConvenientService::Service]
          # @return [void]
          #
          def rollback_service(service)
            Utils::Object.safe_send(service, :rollback_result)
          end

          ##
          # Calls organizer own rollback.
          # Then calls organizer steps rollbacks with nestings in the reverse order.
          #
          # @param organizer [ConvenientService::Service]
          # @return [void]
          #
          def rollback_organizer(organizer)
            rollback_service(organizer)

            organizer.steps
              .select(&:completed?)
              .reject(&:method_step?)
              .reverse_each { |step| rollback_result(step.service_result) }
          end
        end
      end
    end
  end
end
