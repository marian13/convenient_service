# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Step
            module Commands
              class CastParams < Support::Command
                attr_reader :original_params

                def initialize(original_params:)
                  @original_params = original_params
                end

                def call
                  Structs::Params.new(
                    service: service,
                    inputs: inputs,
                    outputs: outputs,
                    index: index,
                    container: container,
                    organizer: organizer
                  )
                end

                def service
                  @service ||= Entities::Service.cast!(original_params.service)
                end

                ##
                # TODO: `cast_many`, `cast_many!`.
                #
                def inputs
                  @inputs ||= original_params.inputs.map { |input| Entities::Method.cast!(input, direction: :input) }
                end

                def outputs
                  @outputs ||= original_params.outputs.map { |output| Entities::Method.cast!(output, direction: :output) }
                end

                def index
                  @index ||= original_params.index
                end

                def container
                  @container ||= Entities::Service.cast!(original_params.container)
                end

                def organizer
                  @organizer ||= original_params.organizer
                end
              end
            end
          end
        end
      end
    end
  end
end
