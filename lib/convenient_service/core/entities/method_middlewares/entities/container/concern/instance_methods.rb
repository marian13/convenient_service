# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Concern
              module InstanceMethods
                include Support::Copyable

                ##
                # @!attribute [r] klass
                #   @return [Class]
                #
                attr_reader :klass

                ##
                # @param klass [Class]
                # @return [void]
                #
                def initialize(klass:)
                  @klass = klass
                end

                ##
                # @return [Module]
                #
                def methods_middlewares_callers
                  @methods_middlewares_callers ||= Commands::ResolveMethodsMiddlewaresCallers.call(container: self)
                end

                ##
                # @param scope [:instance, :class]
                # @param method [Symbol]
                # @return [Boolean]
                #
                def define_method_middlewares_caller!(scope, method)
                  Commands::DefineMethodMiddlewaresCaller.call(scope: scope, method: method, container: self)
                end

                ##
                # @return [void]
                #
                def prepend_methods_middlewares_callers_to_container
                  klass.prepend(methods_middlewares_callers)
                end

                ##
                # @param other [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container, Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if klass != other.klass

                  true
                end

                ##
                # @return [Hash]
                #
                def to_kwargs
                  {klass: klass}
                end
              end
            end
          end
        end
      end
    end
  end
end
