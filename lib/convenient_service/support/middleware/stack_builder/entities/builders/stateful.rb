# frozen_string_literal: true

require_relative "stateful/exceptions"

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Stateful
              ##
              # @!attribute [r] stack
              #   @return [Array<#call<Hash>>]
              #
              attr_reader :stack

              ##
              # @!attribute [r] name
              #   @return [String]
              #
              attr_reader :name

              ##
              # @param kwargs [Hash{Symbol => Object}]
              # @return [void]
              #
              def initialize(**kwargs)
                @name = kwargs.fetch(:name) { "Stack" }
                @stack = kwargs.fetch(:stack) { [] }
                @index = -1
              end

              ##
              # @return [Boolean]
              #
              def empty?
                stack.empty?
              end

              ##
              # @param some_middleware [#call<Hash>]
              # @return [Boolean]
              #
              def has?(some_middleware)
                stack.any? { |middleware| middleware == some_middleware }
              end

              ##
              # @return [Boolean]
              #
              def clear
                stack.clear

                self
              end

              ##
              # @param env [Hash{Symbol => Object}]
              # @return [Object] Can be any type.
              #
              # @internal
              #   NOTE: When stack is empty - `env` is returned. Just like `ruby-middleware` does.
              #   NOTE: Once middleware backends are unified, consider to create new object to ensure thread-safety.
              #   NOTE: Once middleware backends are unified, move `stack.empty?` and `index == stack.size - 1` to entrypoint method.
              #
              #   TODO: Direct specs.
              #
              def call(env)
                return env if stack.empty?

                self.index += 1

                if index == stack.size - 1
                  stack[index].call(env)
                else
                  stack[index].new(self).call(env)
                end
              ensure
                self.index = -1
              end

              ##
              # @param middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              def unshift(middleware)
                stack.unshift(middleware)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              alias_method :prepend, :unshift

              ##
              # @param middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              def use(middleware)
                stack << middleware

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              alias_method :append, :use

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware]
              #
              def insert(index_or_middleware, other_middleware)
                index = cast_index(index_or_middleware)

                stack.insert(index, other_middleware)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              alias_method :insert_before, :insert

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware]
              #
              def insert_after(index_or_middleware, other_middleware)
                index = cast_index(index_or_middleware)

                stack.insert(index + 1, other_middleware)

                self
              end

              ##
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              def insert_before_each(other_middleware)
                @stack = stack.reduce([]) { |stack, middleware| stack.push(other_middleware, middleware) }

                self
              end

              ##
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              def insert_after_each(other_middleware)
                @stack = stack.reduce([]) { |stack, middleware| stack.push(middleware, other_middleware) }

                self
              end

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware]
              #
              def replace(index_or_middleware, other_middleware)
                index = cast_index(index_or_middleware)

                stack[index] = other_middleware

                self
              end

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware]
              #
              def delete(index_or_middleware)
                index = cast_index(index_or_middleware)

                stack.delete_at(index)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              alias_method :remove, :delete

              ##
              # @param other [Object] Can be any type.
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
              def to_a
                stack
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
              #
              def dup
                self.class.new(name: name.dup, stack: stack.dup)
              end

              private

              ##
              # @!attribute [r] index
              #   @return [Integer]
              #
              attr_accessor :index

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @return [Integer]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack::Exceptions::MissingMiddleware]
              #
              def cast_index(index_or_middleware)
                return index_or_middleware if index_or_middleware.instance_of?(Integer)

                index = stack.find_index { |middleware| middleware == index_or_middleware }

                ::ConvenientService.raise Exceptions::MissingMiddleware.new(middleware: index_or_middleware) unless index

                index
              end
            end
          end
        end
      end
    end
  end
end
