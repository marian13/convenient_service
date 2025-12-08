# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveRollbacks
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
          # @internal
          #   IMPORTANT: Uses recursion inside `rollback_organizer`. Recursion has two exit conditions. When service has no steps. When service has only method steps.
          #
          def rollback_result(result)
            result.from_step? ? rollback_organizer(result.service) : rollback_service(result.service)
          end

          ##
          # Calls service rollback.
          #
          # @param service [ConvenientService::Service]
          # @return [void]
          #
          # @note All rollback exceptions are automatically rescued. That is done to NOT skip the rest of rollbacks just because one of them raises exception. Such skipping usually leads to the worse and even more inconsistent system state.
          #
          # @note Rollback exception log.
          #   class Service
          #     include ConvenientService::Standard::Config.with(:rollbacks)
          #
          #     step OtherService
          #
          #     def rollback_result
          #       puts "Hello from `Service` rollback!" # Still executed although `OtherService` rollback raises exception.
          #     end
          #   end
          #
          #   class OtherService
          #     include ConvenientService::Standard::Config.with(:rollbacks)
          #
          #     def result
          #       16 / 0 # Service raises `ZeroDivisionError` exception to trigger rollback.
          #
          #       success
          #     end
          #
          #     def rollback_result
          #       [].keys # Rollback raises `NoMethodError` exception that is ignored by other rollbacks, but still can be logged by the end-user in `rescue` statement.
          #     rescue => exception
          #       puts exception.class
          #       puts exception.message
          #       puts exception.backtrace.to_a.take(10)
          #     end
          #   end
          #
          def rollback_service(service)
            Utils::Object.safe_send(service, :rollback_result)
          end

          ##
          # Calls organizer rollback.
          # Then calls organizer steps rollbacks with nestings in the reverse order.
          #
          # @param organizer [ConvenientService::Service]
          # @return [void]
          #
          def rollback_organizer(organizer)
            rollback_service(organizer)

            organizer.steps
              .select(&:evaluated?)
              .reject(&:method_step?)
              .reverse_each { |step| rollback_result(step.service_result) }
          end
        end
      end
    end
  end
end
