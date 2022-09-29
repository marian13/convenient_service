# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          ##
          #
          #
          class Stack
            attr_reader :name, :stack

            ##
            #
            #
            def initialize(**kwargs)
              @name = kwargs[:name]
              @stack = kwargs.fetch(:stack) { Support::Middleware::StackBuilder.new(name: @name) }
            end

            ##
            #
            #
            def dup
              self.class.new(name: name.dup, stack: stack.dup)
            end

            ##
            #
            #
            def call(env)
              stack.call(env)
            end

            ##
            #
            #
            def insert_before(index_or_middleware, middleware)
              stack.insert_before index_or_middleware, middleware

              self
            end

            ##
            #
            #
            def insert_after(index_or_middleware, middleware)
              stack.insert_after index_or_middleware, middleware

              self
            end

            ##
            #
            #
            def insert_before_each(middleware)
              stack.insert_before_each middleware

              self
            end

            ##
            #
            #
            def insert_after_each(middleware)
              stack.insert_after_each middleware

              self
            end

            ##
            #
            #
            def replace(index_or_middleware, middleware)
              stack.replace index_or_middleware, middleware

              self
            end

            ##
            #
            #
            def delete(index_or_middleware)
              stack.delete index_or_middleware

              self
            end

            ##
            #
            #
            def use(middleware)
              stack.use middleware

              self
            end

            ##
            # NOTE: This method is a subject to change.
            # TODO: Refactor.
            #
            def empty?
              to_a.empty?
            end

            ##
            # NOTE: This method is a subject to change.
            #
            def to_a
              stack.to_a
            end

            ##
            # TODO: Unify `inspect`. Specs for `inspect`.
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
