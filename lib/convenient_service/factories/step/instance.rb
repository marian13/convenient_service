# frozen_string_literal: true

##
# WIP: Factory API is NOT well-thought yet. It will be revisited and completely refactored at any time.
#
module ConvenientService
  module Factories
    module Step
      module Instance
        ##
        # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
        #
        def create_step_instance
          service_class =
            ::Class.new do
              include ::ConvenientService::Configs::Standard

              ##
              # IMPORTANT:
              #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
              #   - It will be reenabled after the introduction of thread-safety specs.
              #   - Do not use it in production yet.
              #
              middlewares :step, scope: :class do
                use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
              end

              step :result

              def result
                success
              end
            end

          service_instance = service_class.new

          service_instance.steps.first
        end
      end
    end
  end
end
