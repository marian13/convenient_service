# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Proc < Callers::Base
                  def calculate_value(method)
                    method.organizer.instance_exec(&proc)
                  end

                  def define_output_in_container!(container, index:, method:)
                    true
                  end

                  private

                  alias_method :proc, :object
                end
              end
            end
          end
        end
      end
    end
  end
end
