# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              ##
              # TODO: Rename.
              #
              module HasResult
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                  #
                  alias_method :step, :entity

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer]
                  #
                  # @internal
                  #   NOTE: Convents a foreign result received from `service_result` to own result.
                  #   TODO: `service.result`.
                  #
                  def next(...)
                    result = chain.next(...)

                    result.copy(overrides: {kwargs: {data: extract_data(result), step: step, service: step.organizer}})
                  end

                  private

                  ##
                  # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @return [Hash]
                  #
                  # @internal
                  #   TODO: Remove `step.outputs.none?` to enforce users to specify outputs for all steps. Will be a breaking change.
                  #
                  def extract_data(result)
                    return result.unsafe_data.to_h if result.status.unsafe_not_success?
                    return result.unsafe_data.to_h if step.outputs.none?

                    step.outputs.each { |output| ::ConvenientService.raise Step::Exceptions::StepResultDataNotExistingAttribute.new(step: step, key: output.key.to_sym) unless result.unsafe_data.has_attribute?(output.key.to_sym) }

                    step.outputs.reduce({}) { |values, output| values.merge(output.name.to_sym => result.unsafe_data[output.key.to_sym]) }
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
