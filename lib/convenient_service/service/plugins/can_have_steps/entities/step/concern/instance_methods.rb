# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          ##
          # @internal
          #   TODO: Extract `StepDefinition`. This way `has_organizer?` check can be avoided completely.
          #
          class Step
            module Concern
              module InstanceMethods
                include Support::Copyable
                include Support::Delegate

                delegate \
                  :success?,
                  :failure?,
                  :error?,
                  :not_success?,
                  :not_failure?,
                  :not_error?,
                  :data,
                  :message,
                  :code,
                  :unsafe_data,
                  :unsafe_message,
                  :unsafe_code,
                  to: :result

                delegate \
                  :service,
                  :outputs,
                  :index,
                  :container,
                  :organizer,
                  :extra_kwargs,
                  to: :params

                ##
                # @param args [Array]
                # @param kwargs [Hash]
                # @return [void]
                #
                def initialize(*args, **kwargs)
                  @args = args
                  @kwargs = kwargs
                end

                ##
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if service != other.service
                  return false if inputs != other.inputs
                  return false if outputs != other.outputs
                  return false if index != other.index
                  return false if container != other.container
                  return false if organizer != other.organizer

                  true
                end

                ##
                # @return [Boolean]
                #
                def has_organizer?
                  Utils.to_bool(organizer)
                end

                ##
                # @return [Boolean]
                #
                def has_reassignment?(name)
                  outputs.any? { |output| output.reassignment?(name) }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method, nil]
                #
                def reassignment(name)
                  outputs.find { |output| output.reassignment?(name) }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params]
                #
                def params
                  @params ||= resolve_params
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def inputs
                  @inputs ||= params.inputs.map { |input| input.copy(overrides: {kwargs: {organizer: organizer}}) }
                end

                ##
                # @return [Hash{Symbol => Object}]
                #
                def input_values
                  @input_values ||= calculate_input_values
                end

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @note `service_result` has middlewares.
                #
                # @internal
                #   IMPORTANT: `service.result(**input_values)` is the reason, why services should have only kwargs as arguments.
                #
                def service_result
                  assert_has_organizer!

                  service.klass.result(**input_values)
                end

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @note `result` has middlewares.
                #
                def result
                  convert_to_step_result(service_result)
                end

                ##
                # @return [String]
                #
                # @internal
                #   TODO: printable service for methods steps.
                #
                def printable_service
                  service.klass.to_s
                end

                ##
                # @return [Class]
                #
                def service_class
                  service.klass
                end

                ##
                # @return [void]
                #
                def trigger_callback
                  organizer.step(index)
                end

                ##
                # @return [void]
                # @raise [ConvenientService::Error]
                #
                def validate!
                  inputs.each { |input| input.validate_as_input_for_container!(container) }

                  outputs.each { |output| output.validate_as_output_for_container!(container) }

                  true
                end

                ##
                # @return [void]
                #
                def define!
                  outputs.each { |output| output.define_output_in_container!(container, index: index) }

                  true
                end

                ##
                # @return [Array]
                #
                def to_args
                  [service]
                end

                ##
                # @return [Hash]
                #
                def to_kwargs
                  kwargs.merge(in: inputs, out: outputs, index: index, container: container, organizer: organizer)
                end

                private

                ##
                # @!attribute [r] args
                #   @return [Array]
                #
                attr_reader :args

                ##
                # @!attribute [r] kwargs
                #   @return [Hash]
                #
                attr_reader :kwargs

                ##
                # @internal
                #   TODO: Commands instead of private methods.
                #
                def calculate_input_values
                  assert_has_organizer!

                  inputs.reduce({}) { |values, input| values.merge(input.key.to_sym => input.value) }
                end

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                def convert_to_step_result(result)
                  result.copy(overrides: {kwargs: {step: self, service: organizer}})
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Structs::Params]
                #
                def resolve_params
                  original_params = Commands::ExtractParams.call(args: args, kwargs: kwargs)

                  Commands::CastParams.call(original_params: original_params)
                end

                ##
                # @return [void]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                def assert_has_organizer!
                  return if has_organizer?

                  raise Errors::StepHasNoOrganizer.new(step: self)
                end
              end
            end
          end
        end
      end
    end
  end
end
