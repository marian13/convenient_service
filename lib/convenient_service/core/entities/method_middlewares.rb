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
        def initialize(scope:, method:, container:)
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
        # @param configuration_block [Proc]
        # @return [ConvenientService::Core::Entities::MethodMiddlewares]
        #
        # @internal
        #   TODO: Util to check if block has one required positional argument.
        #
        def configure(&configuration_block)
          Utils::Proc.exec_config(configuration_block, stack)

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
        # @internal
        #   Stack backend will be rewritten in Core v3 in order to optimize performance of `stack.dup`.
        #   TODO: Measure before any rewrite.
        #
        def call(env, original)
          stack.dup.use(original).call(env.merge(method: method))
        end

        ##
        # @param other [ConvenientService::Core::Entities::MethodMiddlewares, Object]
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if scope != other.scope
          return false if method != other.method
          return false if container != other.container
          return false if stack != other.stack

          true
        end

        ##
        # @return [Array<ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware>]
        #
        def to_a
          stack.to_a.map(&:first)
        end

        protected

        ##
        # @!attribute [r] scope
        #   @return [:instance, :class]
        #
        attr_reader :scope

        ##
        # @!attribute [r] method
        #   @return [Symbol, String]
        #
        attr_reader :method

        ##
        # @!attribute [r] container
        #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
        #
        attr_reader :container

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
        #
        def stack
          @stack ||= Entities::Stack.new(name: stack_name)
        end

        private

        ##
        # @return [String]
        #
        def stack_name
          @stack_name ||= Commands::GenerateStackName.call(method: method, scope: scope, container: container)
        end
      end
    end
  end
end
