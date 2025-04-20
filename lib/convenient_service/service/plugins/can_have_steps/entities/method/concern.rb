# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Concern
              include Support::Concern

              included do |method_klass|
                method_klass.include Support::Castable
                method_klass.include Support::Copyable

                method_klass.include InstanceMethods

                method_klass.extend ClassMethods
              end
            end
          end
        end
      end
    end
  end
end
