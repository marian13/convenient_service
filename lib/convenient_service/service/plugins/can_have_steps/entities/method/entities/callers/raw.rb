# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Raw < Callers::Base
                  def calculate_value(method)
                    raw_value.unwrap
                  end

                  def validate_as_input_for_container!(container, method:)
                    true
                  end

                  def validate_as_output_for_container!(container, method:)
                    ##
                    # TODO: Better error message.
                    #
                    ::ConvenientService.raise Exceptions::OutputMethodRawValue.new(container: container, method: method)
                  end

                  def define_output_in_container!(container, index:, method:)
                    true
                  end

                  private

                  alias_method :raw_value, :object
                end
              end
            end
          end
        end
      end
    end
  end
end
