# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/class_methods"
require_relative "concern/instance_methods"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Chain < Middlewares::Base
                  module Concern
                    include Support::Concern

                    included do |middleware_class|
                      middleware_class.include InstanceMethods

                      middleware_class.extend ClassMethods
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
end
