# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            return chain.next(...) if entity.steps.none?

            entity.steps.each_evaluated_step do |step|
              step.save_outputs_in_organizer!

              step.trigger_callback

              step.mark_as_completed!
            end

            entity.steps.result
          end
        end
      end
    end
  end
end
