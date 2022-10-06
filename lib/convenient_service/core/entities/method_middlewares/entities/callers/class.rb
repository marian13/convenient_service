# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Callers
            class Class < Callers::Base
              ##
              # @return [void]
              #
              def commit_config!
                entity.commit_config!
              end

              ##
              # @return [Array<Class, Module>]
              #
              def ancestors
                entity.singleton_class.ancestors
              end

              ##
              # @return [Module]
              #
              def methods_middlewares_callers
                entity::ClassMethodsMiddlewaresCallers
              end
            end
          end
        end
      end
    end
  end
end
