# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Callers
            class Base
              include Support::AbstractMethod
              include Support::Copyable

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
              # @return [Module, nil]
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
              #   ancestors_greater_than_methods_middlewares_callers # For the entity defined above.
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
              #   ancestors_greater_than_methods_middlewares_callers # For the entity defined above.
              #   # [#<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]# [Service::ClassMethodsMiddlewaresCallers, #<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
              #
              # @internal
              #   NOTE: greater than -> futher in the inheritance chain than
              #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-3E
              #
              #   NOTE: lower than -> closer in the inheritance chain than
              #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-ancestors
              #
              def ancestors_greater_than_methods_middlewares_callers
                Utils::Array.keep_after(ancestors, methods_middlewares_callers)
              end

              ##
              # @param method_name [Symbol, String]
              # @return [Method, nil]
              #
              def resolve_super_method(method_name)
                commit_config!

                method = Utils::Array.find_yield(ancestors_greater_than_methods_middlewares_callers) { |ancestor| Utils::Module.get_own_instance_method(ancestor, method_name, private: true) }

                return unless method

                method.bind(entity)
              end

              ##
              # @param other [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base, Object]
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if entity != other.entity

                true
              end

              ##
              # @return [Hash]
              #
              def to_kwargs
                {entity: entity}
              end
            end
          end
        end
      end
    end
  end
end
