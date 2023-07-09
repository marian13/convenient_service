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

                ##
                # @return [Boolean]
                #
                delegate :success?, to: :result

                ##
                # @return [Boolean]
                #
                delegate :failure?, to: :result

                ##
                # @return [Boolean]
                #
                delegate :error?, to: :result

                ##
                # @return [Boolean]
                #
                delegate :not_success?, to: :result

                ##
                # @return [Boolean]
                #
                delegate :not_failure?, to: :result

                ##
                # @return [Boolean]
                #
                delegate :not_error?, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                #
                delegate :data, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                #
                delegate :message, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                #
                delegate :code, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                #
                delegate :unsafe_data, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                #
                delegate :unsafe_message, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                #
                delegate :unsafe_code, to: :result

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                # @internal
                #   TODO: Return service instance to be compatible with result.
                #
                delegate :service, to: :params

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                # @internal
                #   TODO: Create dedicated classes for input and output methods.
                #
                delegate :outputs, to: :params

                ##
                # @return [Integer]
                #
                delegate :index, to: :params

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                delegate :container, to: :params

                ##
                # @return [Hash{Symbol => Object}]
                #
                delegate :extra_kwargs, to: :params

                ##
                # @param args [Array<Object>]
                # @param kwargs [Hash{Symbol => Object}]
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
                # @internal
                #   TODO: Currently `==` does NOT compare `extra_kwargs`. Is it OK?
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if service != other.service
                  return false if inputs != other.inputs
                  return false if outputs != other.outputs
                  return false if index != other.index
                  return false if container != other.container
                  return false if organizer(raise_when_missing: false) != other.organizer(raise_when_missing: false)

                  true
                end

                ##
                # @return [Boolean]
                #
                def has_organizer?
                  Utils.to_bool(organizer(raise_when_missing: false))
                end

                ##
                # @return [Boolean]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                def has_reassignment?(name)
                  outputs.any? { |output| output.reassignment?(name) }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method, nil]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
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
                # @return [ConvenientService::Service]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                # @internal
                #   NOTE: `raise_when_missing` option is inspired by `where.missing` in Rails.
                #   - https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-missing
                #   - https://boringrails.com/tips/activerecord-where-missing-associations
                #
                def organizer(raise_when_missing: true)
                  @organizer ||= params.organizer

                  raise Errors::StepHasNoOrganizer.new(step: self) if @organizer.nil? && raise_when_missing

                  @organizer
                end

                ##
                # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method>]
                #
                def inputs
                  @inputs ||= params.inputs.map { |input| input.copy(overrides: {kwargs: {organizer: organizer(raise_when_missing: false)}}) }
                end

                ##
                # @return [Hash{Symbol => Object}]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                def input_values
                  @input_values ||= calculate_input_values
                end

                ##
                # @return [Hash{Symbol => Object}]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                def output_values
                  @output_values ||= result.unsafe_data.to_h.slice(*outputs.map(&:key).map(&:to_sym))
                end

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                # @note `service_result` has middlewares.
                #
                # @internal
                #   IMPORTANT: `service.result(**input_values)` is the reason, why services should have only kwargs as arguments.
                #
                def service_result
                  service.klass.result(**input_values)
                end

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                # @note `result` has middlewares.
                #
                def result
                  convert_to_step_result(service_result)
                end

                ##
                # @return [String]
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
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
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
                # @return [Array<Object>]
                #
                def to_args
                  to_arguments.args
                end

                ##
                # @return [Hash{Symbol => Object}]
                #
                def to_kwargs
                  to_arguments.kwargs
                end

                ##
                # @return [ConveninentService::Support::Arguments]
                #
                def to_arguments
                  Support::Arguments.new(service, **kwargs.merge(in: inputs, out: outputs, index: index, container: container, organizer: organizer(raise_when_missing: false)))
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
                # @return [Hash{Symbol => Object}]
                # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer]
                #
                # @internal
                #   TODO: Commands instead of private methods.
                #
                def calculate_input_values
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
              end
            end
          end
        end
      end
    end
  end
end
