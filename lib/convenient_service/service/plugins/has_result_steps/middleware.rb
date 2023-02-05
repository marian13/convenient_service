# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
          #
          def next(...)
            return chain.next(...) if entity.steps.none?

            last_step.result.copy
          end

          private

          ##
          # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
          #
          # @internal
          #   `entity.step(index)` is used as a hook (or in other words to trigger callbacks).
          #
          def last_step
            @last_step ||= entity.steps.find.with_index { |step, index| step.not_success?.tap { entity.step(index) } } || entity.steps.last
          end
        end
      end
    end
  end
end
