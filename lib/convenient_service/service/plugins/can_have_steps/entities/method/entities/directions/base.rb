# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Directions
                class Base
                  include Support::AbstractMethod
                  include Support::Copyable

                  ##
                  # @return [Boolean]
                  # @raise [ConvenientService::Error]
                  #
                  abstract_method :validate_as_input_for_container!

                  ##
                  # @return [Boolean]
                  # @raise [ConvenientService::Error]
                  #
                  abstract_method :validate_as_output_for_container!

                  ##
                  # @return [Boolean]
                  #
                  abstract_method :define_output_in_container!

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    true
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
