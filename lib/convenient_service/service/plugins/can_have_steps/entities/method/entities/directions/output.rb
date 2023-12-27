# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Directions
                class Output < Base
                  def validate_as_input_for_container!(container, method:)
                    ::ConvenientService.raise Exceptions::MethodIsNotInputMethod.new(method: method, container: container)
                  end

                  def validate_as_output_for_container!(container, method:)
                    true
                  end

                  def define_output_in_container!(container, index:, method:)
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
