# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Commands
              class CastParams < Support::Command
                ##
                # @!attribute [r] original_params
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params]
                #
                attr_reader :original_params

                ##
                # @param original_params [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params]
                # @return [void]
                #
                def initialize(original_params:)
                  @original_params = original_params
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params]
                #
                def call
                  Structs::Params.new(
                    service: service,
                    inputs: inputs,
                    outputs: outputs,
                    index: index,
                    container: container,
                    organizer: organizer,
                    extra_kwargs: extra_kwargs
                  )
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                def service
                  @service ||= Entities::Service.cast!(original_params.service)
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                # @internal
                #   TODO: `cast_many`, `cast_many!`.
                #
                def inputs
                  @inputs ||= original_params.inputs.map { |input| Entities::Method.cast!(input, direction: :input) }
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def outputs
                  @outputs ||= original_params.outputs.map { |output| Entities::Method.cast!(output, direction: :output) }
                end

                ##
                # @return [Integer]
                #
                def index
                  @index ||= original_params.index
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                def container
                  @container ||= Entities::Service.cast!(original_params.container)
                end

                ##
                # @return [ConvenientService::Service]
                #
                def organizer
                  @organizer ||= original_params.organizer
                end

                ##
                # @return [Hash{Symbol => Object}]
                #
                def extra_kwargs
                  @extra_kwargs ||= original_params.extra_kwargs
                end
              end
            end
          end
        end
      end
    end
  end
end
