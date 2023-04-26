# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        class Middleware < MethodChainMiddleware
          intended_for :result

          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          def next(...)
            return chain.next(...) if entity.steps.none?

            last_completed_step.result.copy
          end

          private

          ##
          # Steps are executed in the same order as they were defined by the end user.
          # A step is considered completed right after its status is checked.
          # If a NOT successful step is encountered, all the remaining steps are NOT evaluated.
          # As a result, the `last_completed_step` is either the first NOT successful step or the last step from all steps.
          #
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          def last_completed_step
            @last_completed_step ||= find_first_not_successful_step_with_side_effects_during_lookup || just_take_last_step_since_all_steps_are_successful
          end

          ##
          # Finds first not successful step.
          # Runs (intentional) side effects during the lookup.
          # The lookup is made by Ruby's `Enumerable#find`.
          # As a result, side effects are executed only for evaluated steps.
          #
          # Each iteration marks step as completed.
          # Each iteration triggers callback.
          #
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step, nil]
          #
          # @internal
          #   IMPORTANT: `step` status MUST be checked before marking it as completed.
          #   IMPORTANT: `step` status MUST be checked before triggering callback.
          #
          #   NOTE: @marian13 you already tried to come up with a better name to express the idea that this method has side effects numerous amount of times.
          #   Do NOT spend too much time on that again, you have a lot of other tasks to do.
          #
          def find_first_not_successful_step_with_side_effects_during_lookup
            entity.steps.find do |step|
              step.not_success?
                .tap { step.mark_as_completed! }
                .tap { step.trigger_callback }
            end
          end

          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          def just_take_last_step_since_all_steps_are_successful
            entity.steps.last
          end
        end
      end
    end
  end
end
