# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Base
                  include Support::AbstractMethod
                  include Support::Copyable

                  ##
                  # @!attribute [r] object
                  #   @return [Object] Can be any type.
                  #
                  # @internal
                  #   TODO: A better name for `object`. Wrapped object, `target`?
                  #
                  attr_reader :object

                  ##
                  # @return [Object] Can be any type.
                  #
                  abstract_method :calculate_value

                  ##
                  # @return [Boolean]
                  #
                  abstract_method :define_output_in_container!

                  ##
                  # @param object [Object] Can be any type.
                  # @return [void]
                  #
                  def initialize(object)
                    @object = object
                  end

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if object != other.object

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
                    Support::Arguments.new(object)
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
