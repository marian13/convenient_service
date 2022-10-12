# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Stack
            ##
            # @!attribute [r] name
            #   @return [String]
            #
            attr_reader :name

            ##
            # @!attribute [r] stack
            #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            attr_reader :stack

            ##
            # @param name [String]
            # @param stack [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack, nil]
            # @return [void]
            #
            def initialize(name:, stack: nil)
              @name = name
              @stack = stack || Support::Middleware::StackBuilder.new(name: name)
            end

            ##
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def dup
              self.class.new(name: name.dup, stack: stack.dup)
            end

            ##
            # @param env [Hash]
            # @return [Object] Can be any type.
            #
            def call(env)
              stack.call(env)
            end

            ##
            # @param index_or_middleware [Integer, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def insert_before(index_or_middleware, middleware)
              stack.insert_before index_or_middleware, middleware

              self
            end

            ##
            # @param index_or_middleware [Integer, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def insert_after(index_or_middleware, middleware)
              stack.insert_after index_or_middleware, middleware

              self
            end

            ##
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def insert_before_each(middleware)
              stack.insert_before_each middleware

              self
            end

            ##
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def insert_after_each(middleware)
              stack.insert_after_each middleware

              self
            end

            ##
            # @param index_or_middleware [Integer, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def replace(index_or_middleware, middleware)
              stack.replace index_or_middleware, middleware

              self
            end

            ##
            # @param index_or_middleware [Integer, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def delete(index_or_middleware)
              stack.delete index_or_middleware

              self
            end

            ##
            # @param middleware [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Middleware]
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Stack]
            #
            def use(middleware)
              stack.use middleware

              self
            end

            ##
            # @return [Boolean]
            #
            # @internal
            #   NOTE: This method is a subject to change.
            #   TODO: Refactor.
            #
            def empty?
              to_a.empty?
            end

            ##
            # @param other [ConvenientService::Core::Entities::Concerns::Entities::Stack, Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if name != other.name
              return false if stack != other.stack

              true
            end

            ##
            # @return [Array]
            #
            # @internal
            #   NOTE: This method is a subject to change.
            #   TODO: Document array return items.
            #
            def to_a
              stack.to_a
            end

            ##
            # @return [String]
            #
            # @internal
            #   TODO: Unify `inspect`. Specs for `inspect`.
            #
            def inspect
              to_a.inspect
            end
          end
        end
      end
    end
  end
end
