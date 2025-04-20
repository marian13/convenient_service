# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                module Concern
                  include Support::Concern

                  included do |container_klass|
                    container_klass.include Support::Castable

                    container_klass.include InstanceMethods

                    container_klass.extend ClassMethods
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
