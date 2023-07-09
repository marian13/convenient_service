# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              class Name
                include Support::Copyable
                include Support::Delegate

                ##
                # @!attribute [r] value
                #   @return [Symbol]
                #
                attr_reader :value

                ##
                # @return [String]
                #
                delegate :to_s, :to_sym, to: :value

                ##
                # @return [Symbol]
                #
                delegate :to_sym, to: :value

                ##
                # @param value [Symbol]
                # @return [void]
                #
                def initialize(value)
                  @value = value
                end

                ##
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if value != other.value

                  true
                end

                ##
                # @return [Array<Object>]
                #
                def to_args
                  to_arguments.args
                end

                ##
                # @return [ConveninentService::Support::Arguments]
                #
                def to_arguments
                  Support::Arguments.new(value)
                end
              end
            end
          end
        end
      end
    end
  end
end
