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
                    action: action,
                    inputs: inputs,
                    outputs: outputs,
                    strict: strict,
                    index: index,
                    container: container,
                    organizer: organizer,
                    extra_kwargs: extra_kwargs
                  )
                end

                ##
                # @return [Object] Can be any type.
                #
                def action
                  @action ||= original_params.action
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def inputs
                  @inputs ||= cast_inputs
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def outputs
                  @outputs ||= cast_outputs
                end

                ##
                # @return [Boolean]
                #
                def strict
                  Utils.memoize_including_falsy_values(self, :@strict) { Utils.to_bool(original_params.strict) }
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
                # @return [ConvenientService::Service, nil]
                #
                def organizer
                  Utils.memoize_including_falsy_values(self, :@organizer) { original_params.organizer }
                end

                ##
                # @return [Hash{Symbol => Object}]
                #
                def extra_kwargs
                  @extra_kwargs ||= original_params.extra_kwargs
                end

                private

                ##
                # @param methods [Array<Symbol, Hash>]
                # @return [Array<Symbol, Hash>]
                #
                # @internal
                #   NOTE:
                #     Currently, hash `inputs` and `outputs` do NOT support extra keys.
                #     Update `size` condition once they start to support them.
                #
                def flatten_methods(methods)
                  return methods unless methods.last.instance_of?(::Hash)
                  return methods if methods.last.keys.size < 2

                  methods.dup.tap(&:pop).concat(methods.last.map { |key, value| {key => value} })
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                # @internal
                #   TODO: `cast_many`, `cast_many!`.
                #
                def cast_inputs
                  inputs = flatten_methods(original_params.inputs)
                  inputs = inputs.map { |input| Entities::Method.cast!(input, direction: :input) }
                  inputs = inputs.map { |input| input.copy(overrides: {kwargs: {organizer: organizer}}) } if organizer

                  inputs
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def cast_outputs
                  outputs = flatten_methods(original_params.outputs)
                  outputs = outputs.map { |output| Entities::Method.cast!(output, direction: :output) }
                  outputs = outputs.map { |output| output.copy(overrides: {kwargs: {organizer: organizer}}) } if organizer

                  outputs
                end
              end
            end
          end
        end
      end
    end
  end
end
