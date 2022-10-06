# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Callers
            class Base
              include Support::AbstractMethod

              ##
              # @!attribute [r] entity
              #   @return [Object, Class]
              #
              attr_reader :entity

              ##
              #
              #
              abstract_method :commit_config!

              ##
              #
              #
              abstract_method :ancestors

              ##
              #
              #
              abstract_method :methods_middlewares_callers

              ##
              # @param entity [Object, Class]
              # @return [void]
              #
              def initialize(entity:)
                @entity = entity
              end

              ##
              # @param method [Symbol, String]
              # @return [Method]
              #
              def resolve_super_method(method)
                commit_config!

                ancestors
                  .then { |ancestors| Utils::Array.drop_while(ancestors, inclusively: true) { |ancestor| ancestor != methods_middlewares_callers } }
                  .find { |ancestor| Utils::Module.has_own_instance_method?(ancestor, method, private: true) }
                  .then { |ancestor| Utils::Module.get_own_instance_method(ancestor, method, private: true) }
                  .bind(entity)
              end
            end
          end
        end
      end
    end
  end
end
