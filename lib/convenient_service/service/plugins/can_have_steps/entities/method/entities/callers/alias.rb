# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Alias < Callers::Base
                  def calculate_value(method)
                    method.organizer.__send__(method.name.to_s)
                  end

                  def validate_as_input_for_container!(container, method:)
                    return true if container.has_defined_method?(method)

                    ::ConvenientService.raise Exceptions::AliasInputMethodIsNotDefinedInContainer.new(method: method, container: container)
                  end

                  def validate_as_output_for_container!(container, method:)
                    return true unless container.has_defined_method?(method)

                    ::ConvenientService.raise Exceptions::AliasOutputMethodIsDefinedInContainer.new(method: method, container: container)
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
