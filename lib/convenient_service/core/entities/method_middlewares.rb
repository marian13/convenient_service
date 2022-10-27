# frozen_string_literal: true

require_relative "method_middlewares/commands"
require_relative "method_middlewares/entities"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        include Support::Delegate

        ##
        # @param scope [:instance, :class]
        # @param method [Symbol, String]
        # @param klass [Class]
        # @return [void]
        #
        def initialize(scope:, method:, klass:)
          @scope = scope
          @method = method
          @klass = klass
        end

        ##
        # @return [String]
        #
        def no_super_method_exception_message_for(entity)
          "super: no superclass method `#{method}' for #{entity}"
        end

        ##
        # @return [Boolean]
        #
        def defined?
          Utils::Module.has_own_instance_method?(methods_middlewares_callers, method)
        end

        ##
        # @return [Boolean]
        #
        def super_method_defined?
          caller.super_method_defined?(method)
        end

        ##
        # @return [Boolean]
        #
        def defined_without_super_method?
          self.defined? && !super_method_defined?
        end

        ##
        # @param configuration_block [Proc]
        # @return [ConvenientService::Core::Entities::MethodMiddlewares]
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
        # @param env [Hash]
        # @param original_method [Proc]
        # @return [Object]
        #
        # @internal
        #   NOTE: Stack is copied in order to be thread-safe.
        #   NOTE: Stack backend will be rewritten in Core v3 in order to optimize performance of `stack.dup`.
        #   TODO: Measure before any rewrite.
        #
        def call(env, original_method)
          stack.dup.use(original_method).call(env.merge(method: method))
        end

        ##
        # @param entity [Object, Class]
        # @return [Method, nil]
        #
        # @internal
        #   NOTE: Consider to remove when support for Ruby 2.7 is dropped.
        #
        def resolve_super_method(entity)
          klass.commit_config!

          caller.resolve_super_method(method, entity)
        end

        ##
        # @param other [ConvenientService::Core::Entities::MethodMiddlewares, Object]
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if scope != other.scope
          return false if method != other.method
          return false if klass != other.klass
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
        # @!attribute [r] klass
        #   @return [Symbol, String]
        #
        attr_reader :klass

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
        #
        def stack
          @stack ||= Entities::Stack.new(name: stack_name)
        end

        private

        ##
        # @return [Module]
        #
        delegate :methods_middlewares_callers, to: :container

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Caller]
        #
        def caller
          @caller ||= Entities::Caller.new(container: container)
        end

        ##
        # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
        #
        def container
          @container ||= Entities::Container.cast!({scope: scope, klass: klass})
        end

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
