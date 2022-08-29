# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # TODO: Specs.
          #
          # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
          #
          #   def next(*args, **kwargs, &block)
          #     return chain.next(*args, **kwargs, &block) if entity.steps.none?
          #
          #     # ...
          #   end
          #
          # rubocop:disable Style/ArgumentsForwarding
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) if entity.steps.none?

            last_step.result
          end
          # rubocop:enable Style/ArgumentsForwarding

          private

          def last_step
            ##
            # TODO: Use `entity.steps.find { |step| step.result.tap { |result| entity.step(result) }.not_success? }' for callbacks.
            #
            @last_step ||= entity.steps.find(&:not_success?) || entity.steps.last
          end
        end
      end
    end
  end
end
