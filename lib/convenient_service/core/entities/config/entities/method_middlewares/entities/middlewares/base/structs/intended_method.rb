# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Base
                  module Structs
                    ##
                    # TODO: IntendedMethod = ::Struct.new(:method, :scope, :entity)
                    #
                    IntendedMethod = ::Struct.new(:method, :scope)
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
