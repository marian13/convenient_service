# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Directions
                class Input < Base
                  def validate_as_input_for_container!(container, method:)
                    true
                  end

                  def validate_as_output_for_container!(container, method:)
                    ::ConvenientService.raise Exceptions::MethodIsNotOutputMethod.new(method: method, container: container)
                  end

                  def define_output_in_container!(container, index:, method:)
                    ::ConvenientService.raise Exceptions::MethodIsNotOutputMethod.new(method: method, container: container)
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
