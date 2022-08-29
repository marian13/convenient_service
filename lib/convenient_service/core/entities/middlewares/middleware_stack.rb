# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      module Middlewares
        class MiddlewareStack
          attr_reader :container, :scope, :method, :name, :stack

          def initialize(**kwargs)
            @method = kwargs.fetch(:method)
            @scope = kwargs.fetch(:scope)
            @container = kwargs.fetch(:container)
            @name = kwargs.fetch(:name) { "Middlewares::#{@container}::#{@scope.capitalize}::#{@method.capitalize}" }
            @stack = kwargs.fetch(:stack) { Support::Middleware::StackBuilder.new(name: @name) }
          end

          def dup
            self.class.new(
              method: method,
              scope: scope,
              container: container,
              name: name.dup,
              stack: stack.dup
            )
          end

          def call(env = {})
            stack.call(env.merge(method: method))
          end

          def insert_before(index_or_middleware, middleware)
            stack.insert_before index_or_middleware, middleware

            self
          end

          def insert_after(index_or_middleware, middleware)
            stack.insert_after index_or_middleware, middleware

            self
          end

          def insert_before_each(middleware)
            stack.insert_before_each middleware

            self
          end

          def insert_after_each(middleware)
            stack.insert_after_each middleware

            self
          end

          def replace(index_or_middleware, middleware)
            stack.replace index_or_middleware, middleware

            self
          end

          def delete(index_or_middleware)
            stack.delete index_or_middleware

            self
          end

          def use(middleware)
            stack.use middleware

            self
          end

          ##
          # NOTE: This method is a subject to change.
          # TODO: Refactor.
          #
          # rubocop:disable Rails/Delegate
          def empty?
            to_a.empty?
          end
          # rubocop:enable Rails/Delegate

          ##
          # NOTE: This method is a subject to change.
          #
          # rubocop:disable Rails/Delegate
          def to_a
            stack.to_a
          end
          # rubocop:enable Rails/Delegate

          ##
          # TODO: Unify `inspect'. Specs for `inspect'.
          #
          # rubocop:disable Rails/Delegate
          def inspect
            to_a.inspect
          end
          # rubocop:enable Rails/Delegate
        end
      end
    end
  end
end
