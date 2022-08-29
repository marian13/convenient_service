# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Proc < Callers::Base
                  def calculate_value(method)
                    method.organizer.instance_exec(&proc)
                  end

                  def validate_as_input_for_container!(container, method:)
                    true
                  end

                  def validate_as_output_for_container!(container, method:)
                    ##
                    # TODO: Better error message.
                    #
                    raise Errors::OutputMethodProc.new(method: method, container: container)
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
