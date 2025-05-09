# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Usual < Callers::Base
                  ##
                  # @return [Boolean]
                  #
                  def usual?
                    true
                  end

                  def calculate_value(method)
                    method.organizer.__send__(method.name.to_s)
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
