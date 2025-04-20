# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSequentialSteps
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            return chain.next(...) if entity.steps.none?

            last_completed_step.result
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
          #
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step, nil]
          #
          # @internal
          #   IMPORTANT: `step` status MUST be checked before marking it as completed.
          #
          #   NOTE: @marian13 you already tried to come up with a better name to express the idea that this method has side effects numerous amount of times.
          #   Do NOT spend too much time on that again, you have a lot of other tasks to do.
          #
          def find_first_not_successful_step_with_side_effects_during_lookup
            entity.steps.find do |step|
              step.status.unsafe_not_success?
                .tap { step.save_outputs_in_organizer! }
                .tap { step.mark_as_evaluated! }
            end
          end

          ##
          # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
          #
          # @internal
          #   NOTE: Custom `Enumerable` objects do NOT implement the `last` method. It is available for `Array` instances.
          #
          def just_take_last_step_since_all_steps_are_successful
            entity.steps[-1]
          end
        end
      end
    end
  end
end
