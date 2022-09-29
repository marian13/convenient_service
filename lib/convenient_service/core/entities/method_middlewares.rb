# frozen_string_literal: true

require_relative "method_middlewares/entities"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        ##
        #
        #
        def initialize(**kwargs)
          @scope = kwargs[:scope]
          @method = kwargs[:method]
          @container = Entities::Container.new(service_class: kwargs[:container])
        end

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares]
        #
        def configure(&configuration_block)
          stack.instance_exec(&configuration_block)

          self
        end

        ##
        # NOTE: Works in a similar way as `Kernel.require`.
        #
        # @return [Boolean]
        #
        def define!
          container.define_method_middlewares_caller!(scope, method)
        end

        ##
        # TODO: Simplify.
        #
        # @return [Object]
        #
        def call(env, original)
          stack.dup.use(original).call(env.merge(method: method))
        end

        ##
        #
        #
        def to_a
          stack.to_a.map(&:first)
        end

        private

        attr_reader :scope, :method, :container

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
        #
        def stack
          @stack ||= Entities::Stack.new(name: stack_name)
        end

        ##
        # @return [String]
        #
        def stack_name
          @stack_name ||= "#{container.service_class}::MethodMiddlewares::#{scope.capitalize}::#{method.capitalize}"
        end
      end
    end
  end
end
