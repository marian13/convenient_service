# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        class Middleware < Core::MethodChainMiddleware
          def next(...)
            return chain.next(...) if entity.steps.none?

            last_step.result.copy
          end

          private

          def last_step
            ##
            # TODO: Use `entity.steps.find { |step| step.result.tap { |result| entity.step(result) }.not_success? }` for callbacks.
            #
            @last_step ||= entity.steps.find(&:not_success?) || entity.steps.last
          end
        end
      end
    end
  end
end
