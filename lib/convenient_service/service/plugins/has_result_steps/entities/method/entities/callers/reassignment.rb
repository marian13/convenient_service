# frozen_string_literal: true

require_relative "reassignment/commands"

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Reassignment < Callers::Base
                  def reassignment?(name:, method:)
                    method.name.value == name
                  end

                  def calculate_value(method)
                    raise
                  end

                  def validate_as_input_for_container!(container, method:)
                    false
                  end

                  def validate_as_output_for_container!(container, method:)
                    ##
                    # TODO:
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
