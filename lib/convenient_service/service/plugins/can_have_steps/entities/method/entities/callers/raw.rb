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
