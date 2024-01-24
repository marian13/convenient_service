# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module HasResult
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                  #
                  # @internal
                  #   NOTE: Convents a foreign result received from `service_result` to own result.
                  #   TODO: `service.result`.
                  #
                  def next(...)
                    chain.next(...).copy(overrides: {kwargs: {step: entity, service: entity.organizer}})
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
