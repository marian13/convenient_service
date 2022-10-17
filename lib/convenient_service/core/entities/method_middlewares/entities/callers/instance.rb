# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Callers
            class Instance < Callers::Base
              ##
              # @return [void]
              #
              def commit_config!
                entity.class.commit_config!
              end

              ##
              # @return [Array<Class, Module>]
              #
              def ancestors
                entity.class.ancestors
              end

              ##
              # @return [Module]
              #
              def methods_middlewares_callers
                Utils::Module.get_own_const(entity.class, :InstanceMethodsMiddlewaresCallers)
              end
            end
          end
        end
      end
    end
  end
end
