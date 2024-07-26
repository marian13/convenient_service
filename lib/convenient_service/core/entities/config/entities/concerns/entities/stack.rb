# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class Concerns
            module Entities
              class Stack
                ##
                # @overload initialize(name:)
                #   @param name [String]
                #   @return [void]
                #
                # @overload initialize(plain_stack:)
                #   @param name [ConvenientService::Support::Middleware::StackBuilder]
                #   @return [void]
                #
                def initialize(name: nil, plain_stack: nil)
                  @plain_stack = plain_stack || Support::Middleware::StackBuilder.by(Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE).new(name: name)
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
                  self.class.new(plain_stack: plain_stack.dup)
                end

                ##
                # Calls stack. In other words, invokes all its middlewares.
                #
                # Wraps `RubyMiddleware::Middleware::Builder#call`.
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L132
                #
                # @param env [Hash]
                # @return Value of the last middleware invocation in the stack.
                #
                def call(env)
                  plain_stack.call(env)
                end

                ##
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                def unshift(concern)
                  plain_stack.unshift(cast(concern))

                  self
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                alias_method :prepend, :unshift

                ##
                # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L88
                #
                def insert(index_or_concern, concern)
                  plain_stack.insert(cast(index_or_concern), cast(concern))

                  self
                end

                ##
                # @see insert
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L94
                #
                alias_method :insert_before, :insert

                ##
                # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L97
                #
                def insert_after(index_or_concern, concern)
                  plain_stack.insert_after(cast(index_or_concern), cast(concern))

                  self
                end

                ##
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L104
                #
                def insert_before_each(concern)
                  plain_stack.insert_before_each(cast(concern))

                  self
                end

                ##
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L111
                #
                def insert_after_each(concern)
                  plain_stack.insert_after_each(cast(concern))

                  self
                end

                ##
                # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L118
                #
                def replace(index_or_concern, concern)
                  plain_stack.replace(cast(index_or_concern), cast(concern))

                  self
                end

                ##
                # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L126
                #
                def delete(index_or_concern)
                  plain_stack.delete(cast(index_or_concern))

                  self
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                alias_method :remove, :delete

                ##
                # @param concern [ConvenientService::Support::Concern, Module]
                # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
                #
                # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L76
                #
                def use(concern)
                  plain_stack.use(cast(concern))

                  self
                end

                ##
                # @return [Boolean]
                #
                def empty?
                  plain_stack.empty?
                end

                ##
                # @param other [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack, Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if plain_stack != other.plain_stack

                  true
                end

                ##
                # @return [Array<ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware>]
                #
                def to_a
                  plain_stack.to_a
                end

                protected

                ##
                # @!attribute [r] stack
                #   @return [ConvenientService::Support::Middleware::StackBuilder]
                #
                attr_reader :plain_stack

                private

                ##
                # @param value [Integer, ConvenientService::Support::Concern, Module]
                # @return [Class]
                #
                def cast(value)
                  return value if value.is_a?(::Integer)

                  Entities::Middleware.cast!(value)
                end
              end
            end
          end
        end
      end
    end
  end
end
