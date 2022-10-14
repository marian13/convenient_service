# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Concerns
        module Entities
          class Stack
            attr_reader :stack, :entity

            def initialize(entity:)
              @stack = Support::Middleware::StackBuilder.new(name: "Concerns::#{entity}")
              @entity = entity
            end

            ##
            # Calls stack. In other words, invokes all its middlewares.
            #
            # Wraps `RubyMiddleware::Middleware::Builder#call`.
            # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L132
            #
            # @param env [Hash]
            #
            # @return Value of the last middleware invocation in the stack.
            #
            def call(env)
              stack.call(env)
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_before(index_or_concern, concern)
              stack.insert_before cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_after(index_or_concern, concern)
              stack.insert_after cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_before_each(concern)
              stack.insert_before_each cast(concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_after_each(concern)
              stack.insert_after_each cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def replace(index_or_concern, concern)
              stack.replace cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def delete(index_or_concern)
              stack.delete cast(index_or_concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def use(concern)
              stack.use cast(concern)

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
            # @param other [ConvenientService::Core::Entities::Concerns::Entities::Stack, Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if stack != other.stack

              true
            end

            private

            def cast(value)
              ##
              # TODO: Command.
              #
              return value if value.is_a?(::Integer)

              ##
              # NOTE: `ruby-middleware` expects a `Class` or object that responds to `call`.
              # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/runner.rb#L52
              # https://github.com/Ibsciss/ruby-middleware#middleware-lambdas
              #
              # IMPORTANT: Must be kept in sync with `def concern` in `ConvenientService::Core::Entities::Concerns::Middleware`.
              #
              ::Class.new(Entities::Middleware).tap do |klass|
                klass.class_exec(value) do |concern|
                  define_singleton_method(:concern) { concern }
                  define_singleton_method(:==) { |other| self.concern == other.concern if other.instance_of?(self.class) }
                end
              end
            end
          end
        end
      end
    end
  end
end
