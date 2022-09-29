# frozen_string_literal: true

require_relative "container/commands"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            attr_reader :service_class

            ##
            # @param [Class] service_class
            #
            def initialize(service_class:)
              @service_class = service_class
            end

            ##
            # @param [:instance, :class] scope
            # @param [Symbol] method
            #
            # @return [Boolean]
            #
            def define_method_middlewares_caller!(scope, method)
              Commands::DefineMethodMiddlewaresCaller.call(scope: scope, method: method, container: self)
            end

            ##
            # @param [:instance, :class] scope
            #
            # @return [Module]
            #
            def resolve_methods_middlewares_callers(scope)
              Commands::ResolveMethodsMiddlewaresCallers.call(scope: scope, container: self)
            end
          end
        end
      end
    end
  end
end
