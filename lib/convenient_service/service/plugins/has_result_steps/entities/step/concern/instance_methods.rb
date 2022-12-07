# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
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
                  to: :result

                delegate \
                  :service,
                  :outputs,
                  :index,
                  :container,
                  :organizer,
                  to: :params

                def initialize(*args, **kwargs)
                  @args = args
                  @kwargs = kwargs
                end

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

                def has_organizer?
                  Utils::Bool.to_bool(organizer)
                end

                def has_reassignment?(name)
                  outputs.any? { |output| output.reassignment?(name) }
                end

                def completed?
                  Utils::Bool.to_bool(@completed)
                end

                def params
                  @params ||= resolve_params
                end

                def inputs
                  @inputs ||= params.inputs.map { |input| input.copy(overrides: {kwargs: {organizer: organizer}}) }
                end

                def input_values
                  @input_values ||= calculate_input_values
                end

                def result
                  @result ||= calculate_result
                end

                def validate!
                  inputs.each { |input| input.validate_as_input_for_container!(container) }

                  outputs.each { |output| output.validate_as_output_for_container!(container) }

                  true
                end

                def define!
                  outputs.each { |output| output.define_output_in_container!(container, index: index) }

                  true
                end

                def to_args
                  [service]
                end

                def to_kwargs
                  {in: inputs, out: outputs, index: index, container: container, organizer: organizer}
                end

                private

                attr_reader :args, :kwargs

                def calculate_input_values
                  assert_has_organizer!

                  inputs.reduce({}) { |values, input| values.merge(input.key.to_sym => input.value) }
                end

                ##
                # @internal
                #   IMPORTANT: `service.result(**input_values)` is the reason, why services should have only kwargs as arguments.
                #
                def calculate_result
                  assert_has_organizer!

                  result = service.result(**input_values)

                  mark_as_completed!

                  result
                end

                def resolve_params
                  original_params = Commands::ExtractParams.call(args: args, kwargs: kwargs)

                  Commands::CastParams.call(original_params: original_params)
                end

                def assert_has_organizer!
                  return if has_organizer?

                  raise Errors::StepHasNoOrganizer.new(step: self)
                end

                def mark_as_completed!
                  @completed = true
                end
              end
            end
          end
        end
      end
    end
  end
end
