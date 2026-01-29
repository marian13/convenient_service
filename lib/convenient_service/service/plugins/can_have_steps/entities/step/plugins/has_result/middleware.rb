# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              ##
              # TODO: Rename. Сurrent name confuses to often.
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

                    result = result.strict if step.strict?

                    result.copy(
                      overrides: {
                        kwargs: {
                          data: extract_data(result),
                          step: step,
                          service: step.organizer,
                          original_service: result.original_service
                        }
                      }
                    )
                  end

                  private

                  ##
                  # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @return [Hash]
                  #
                  # @internal
                  #   TODO: Remove `step.outputs.none?` to enforce users to specify outputs for all steps. Will be a breaking change.
                  #   TODO: Refactor this method. It looks too ugly.
                  #   NOTE: `result_outputs` are usual and alias outputs.
                  #   NOTE: `custom_outputs` are proc and raw outputs.
                  #
                  def extract_data(result)
                    return result.unsafe_data.to_h if result.status.unsafe_not_success?
                    return result.unsafe_data.to_h if step.outputs.none?

                    result_outputs, custom_outputs = step.outputs.partition { |output| output.usual? || output.alias? }

                    result_outputs.each do |output|
                      next if result.unsafe_data.__has_attribute__?(output.key.to_sym)

                      ::ConvenientService.raise Step::Exceptions::StepResultDataNotExistingAttribute.new(step: step, key: output.key.to_sym)
                    end

                    result_values = result_outputs.reduce({}) { |values, output| values.merge(output.name.to_sym => result.unsafe_data[output.key.to_sym]) }

                    custom_values = custom_outputs.reduce({}) { |values, output| values.merge(output.name.to_sym => output.value) }

                    result_values.merge(custom_values)
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
