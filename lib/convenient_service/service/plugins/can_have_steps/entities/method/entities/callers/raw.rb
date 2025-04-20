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
                class Raw < Callers::Base
                  def calculate_value(method)
                    raw_value.unwrap
                  end

                  def define_output_in_container!(container, index:, method:)
                    false
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
