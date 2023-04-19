# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Base
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
