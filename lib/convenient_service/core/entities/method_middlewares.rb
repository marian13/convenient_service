# frozen_string_literal: true

require_relative "method_middlewares/commands"
require_relative "method_middlewares/entities"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        ##
        # @param scope [:instance, :class]
        # @param method [Symbol, String]
        # @param container [Class]
        # @return [void]
        #
        def initialize(:scope, :method, :container)
          @scope = scope
          @method = method
          @container = Entities::Container.new(service_class: container)
        end

        ##
        # @param entity [Object, Class]
        # @param scope [:instance, :class]
        # @param method [Symbol, String]
        # @return [Method, nil]
        #
        def self.resolve_super_method(entity, scope, method)
          caller = Commands::CastCaller.call(other: {entity: entity, scope: scope})

          return unless caller

          caller.resolve_super_method(method)
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
        # @return [Array<ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware>]
        #
        def to_a
          stack.to_a.map(&:first)
        end

        private

        ##
        # @!attrubure [r] scope
        #   @return [:instance, :class]
        #
        attr_reader :scope

        ##
        # @!attrubure [r] method
        #   @return [Symbol, String]
        #
        attr_reader :method

        ##
        # @!attrubure [r] container
        #   @return [Class]
        #
        attr_reader :container

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
        #
        def stack
          @stack ||= Entities::Stack.new(name: stack_name)
        end

        ##
        # @return [String]
        #
        # @internal
        #   TODO: method.camelize.capitalize
        #
        def stack_name
          @stack_name ||= "#{container.service_class}::MethodMiddlewares::#{scope.capitalize}::#{method.capitalize}"
        end
      end
    end
  end
end
