# frozen_string_literal: true

require_relative "reassignment/commands"
require_relative "reassignment/errors"

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Reassignment < Callers::Base
                  def reassignment?(name)
                    ##
                    # TODO: A better name for `object`. Wrapped object, `target`?
                    #
                    object.to_sym == name.to_sym
                  end

                  ##
                  # TODO: Separate `in` and `out` methods?
                  #
                  def calculate_value(method)
                    raise Errors::CallerCanNotCalculateReassignment.new(method: method)
                  end

                  def validate_as_input_for_container!(container, method:)
                    false
                  end

                  def validate_as_output_for_container!(container, method:)
                    ##
                    # TODO: Raise when container has two reassignments with same name.
                    #
                    true
                  end

                  def define_output_in_container!(container, index:, method:)
                    Commands::DefineMethodInContainer.call(method: method, container: container, index: index)
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
