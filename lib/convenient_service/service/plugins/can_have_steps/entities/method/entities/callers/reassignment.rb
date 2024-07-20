# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
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
                    ::ConvenientService.raise Exceptions::CallerCanNotCalculateReassignment.new(method: method)
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
