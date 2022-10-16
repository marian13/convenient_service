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
              # @return [void]
              # @raise [ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden] if NOT overridden in descendant.
              #
              abstract_method :commit_config!

              ##
              # @return [Array<Class, Module>]
              # @raise [ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden] if NOT overridden in descendant.
              #
              abstract_method :ancestors

              ##
              # @return [Module]
              # @raise [ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden] if NOT overridden in descendant.
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
              # Returns ancestors before the `methods_middlewares_callers` module. See the example below.
              # When ancestors do NOT contain `methods_middlewares_callers`, returns an empty array.
              #
              # @return [Array<Class, Module>]
              #
              # @example The entity is an object.
              #   class Service
              #     include ConvenientService::Core
              #
              #     middlewares :result do
              #       use ConvenientService::Plugins::Common::NormalizesEnv
              #     end
              #   end
              #
              #   entity = Service.new
              #
              #   entity.class.ancestors
              #   # [Service::InstanceMethodsMiddlewaresCallers, Service, ConvenientService::Core::InstanceMethods, ConvenientService::Core, ConvenientService::Support::Concern, Object, Kernel, BasicObject]
              #
              #   ancestors_before_methods_middlewares_callers # For the entity defined above.
              #   # [Service, ConvenientService::Core::InstanceMethods, ConvenientService::Core, ConvenientService::Support::Concern, Object, Kernel, BasicObject]
              #
              # @example The entity is class.
              #   class Service
              #     include ConvenientService::Core
              #
              #     middlewares :result, scope: :class do
              #       use ConvenientService::Plugins::Common::NormalizesEnv
              #     end
              #   end
              #
              #   entity = Service
              #
              #   entity.singleton_class.ancestors
              #   # [Service::ClassMethodsMiddlewaresCallers, #<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
              #
              #   ancestors_before_methods_middlewares_callers # For the entity defined above.
              #   # [#<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]# [Service::ClassMethodsMiddlewaresCallers, #<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
              #
              def ancestors_before_methods_middlewares_callers
                return [] unless ancestors.include?(methods_middlewares_callers)

                Utils::Array.drop_while(ancestors, inclusively: true) { |ancestor| ancestor != methods_middlewares_callers }
              end

              ##
              # @param method [Symbol, String]
              # @return [Method]
              #
              def resolve_super_method(method)
                commit_config!

                method = Utils::Array.find_yield(ancestors_before_methods_middlewares_callers) { |ancestor| Utils::Module.get_own_instance_method(ancestor, method, private: true) }

                return unless method

                method.bind(entity)
              end
            end
          end
        end
      end
    end
  end
end
