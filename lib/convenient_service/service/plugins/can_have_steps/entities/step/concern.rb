# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Concern
              include Support::Concern

              included do |step_class|
                step_class.include InstanceMethods
              end
            end
          end
        end
      end
    end
  end
end
