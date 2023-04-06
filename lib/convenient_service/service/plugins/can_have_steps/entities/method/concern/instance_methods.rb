# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Concern
              module InstanceMethods
                include Support::Delegate

                attr_reader :key, :name, :caller, :direction, :organizer

                delegate :to_s, to: :name

                def initialize(key:, name:, caller:, direction:, organizer: nil)
                  @key = key
                  @name = name
                  @caller = caller
                  @direction = direction
                  @organizer = organizer
                end

                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if key != other.key
                  return false if name != other.name
                  return false if caller != other.caller
                  return false if direction != other.direction
                  return false if organizer != other.organizer

                  true
                end

                def has_organizer?
                  Utils::Bool.to_bool(organizer)
                end

                def reassignment?(name)
                  caller.reassignment?(name)
                end

                def validate_as_input_for_container!(container)
                  direction.validate_as_input_for_container!(container, method: self)

                  caller.validate_as_input_for_container!(container, method: self)

                  true
                end

                def validate_as_output_for_container!(container)
                  direction.validate_as_output_for_container!(container, method: self)

                  caller.validate_as_output_for_container!(container, method: self)

                  true
                end

                def define_output_in_container!(container, index:)
                  direction.define_output_in_container!(container, index: index, method: self)

                  caller.define_output_in_container!(container, index: index, method: self)

                  true
                end

                def value
                  @value ||= calculate_value
                end

                def to_kwargs
                  {key: key, name: name, caller: caller, direction: direction, organizer: organizer}
                end

                private

                def calculate_value
                  assert_has_organizer!

                  caller.calculate_value(self)
                end

                ##
                # TODO: Return `true` for valid assertions.
                #
                def assert_has_organizer!
                  return if has_organizer?

                  raise Errors::MethodHasNoOrganizer.new(method: self)
                end
              end
            end
          end
        end
      end
    end
  end
end
