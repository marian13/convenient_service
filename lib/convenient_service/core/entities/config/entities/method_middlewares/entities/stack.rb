# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              ##
              # @internal
              #   TODO: Better error explanations.
              #
              class Stack
                ##
                # @!attribute [r] klass
                #   @return [ConvenientService::Service]
                #
                attr_reader :klass

                ##
                # @overload initialize(klass:, name:)
                #   @param klass [Class]
                #   @param name [String]
                #   @return [void]
                #
                # @overload initialize(klass:, plain_stack:)
                #   @param klass [Class]
                #   @param name [ConvenientService::Support::Middleware::StackBuilder]
                #   @return [void]
                #
                def initialize(klass:, name: nil, plain_stack: nil)
                  @klass = klass
                  @plain_stack = plain_stack || Support::Middleware::StackBuilder.new(name: name)
                end

                ##
                # @return [Set]
                #
                def options
                  klass.options
                end

                ##
                # @return [String]
                #
                def name
                  plain_stack.name
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                def dup
                  self.class.new(klass: klass, plain_stack: plain_stack.dup)
                end

                ##
                # @param env [Hash]
                # @param original [Proc]
                # @return [Object] Can be any type.
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L132
                #
                def call_with_original(env, original)
                  plain_stack.call_with_original(env, original)
                end

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                def unshift(middleware)
                  plain_stack.unshift(middleware)

                  self
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                alias_method :prepend, :unshift

                ##
                # @param index_or_middleware [Integer, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L88
                #
                def insert(index_or_middleware, middleware)
                  plain_stack.insert(index_or_middleware, middleware)

                  self
                end

                ##
                # @see insert
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L94
                #
                alias_method :insert_before, :insert

                ##
                # @param index_or_middleware [Integer, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L97
                #
                def insert_after(index_or_middleware, middleware)
                  plain_stack.insert_after(index_or_middleware, middleware)

                  self
                end

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L104
                #
                def insert_before_each(middleware)
                  plain_stack.insert_before_each(middleware)

                  self
                end

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L111
                #
                def insert_after_each(middleware)
                  plain_stack.insert_after_each(middleware)

                  self
                end

                ##
                # @param index_or_middleware [Integer, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L118
                #
                def replace(index_or_middleware, middleware)
                  plain_stack.replace(index_or_middleware, middleware)

                  self
                end

                ##
                # @param index_or_middleware [Integer, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L126
                #
                def delete(index_or_middleware)
                  plain_stack.delete(index_or_middleware)

                  self
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                alias_method :remove, :delete

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L76
                #
                def use(middleware)
                  plain_stack.use(middleware)

                  self
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                alias_method :append, :use

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @note `observe` exists only for testing purposes. Do NOT use it in production code.
                #
                # @internal
                #   TODO: Raise if middleware is NOT used yet.
                #
                def observe(middleware)
                  plain_stack.replace(middleware, middleware.observable)

                  self
                end

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
                #
                # @note `use_and_observe` exists only for testing purposes. Do NOT use it in production code.
                #
                def use_and_observe(middleware)
                  plain_stack.use(middleware.observable)

                  self
                end

                ##
                # @return [Boolean]
                #
                def empty?
                  plain_stack.empty?
                end

                ##
                # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                # @return [Boolean]
                #
                def has?(middleware)
                  plain_stack.has?(middleware)
                end

                ##
                # @param other [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack, Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if klass != other.klass
                  return false if plain_stack != other.plain_stack

                  true
                end

                ##
                # @return [Array<ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base>]
                #
                def to_a
                  plain_stack.to_a
                end

                protected

                ##
                # @!attribute [r] plain_stack
                #   @return [ConvenientService::Support::Middleware::StackBuilder]
                #
                attr_reader :plain_stack
              end
            end
          end
        end
      end
    end
  end
end
