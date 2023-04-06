# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          def next(...)
            return chain.next(...) if entity.steps.none?

            last_step.result.copy
          end

          private

          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          def last_step
            @last_step ||= entity.steps.find.with_index { |step, index| not_success?(step, index) } || entity.steps.last
          end

          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          # @internal
          #   NOTE: `entity.step(index)` is used as a hook (callbacks trigger).
          #   IMPORTANT: `step` status MUST be checked before triggering callbacks.
          #
          def not_success?(step, index)
            step.not_success?.tap { entity.step(index) }
          end
        end
      end
    end
  end
end
