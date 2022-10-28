# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Concerns
        module Entities
          class Stack
            ##
            # @param name [String]
            # @return [void]
            #
            def initialize(name:)
              @plain_stack = Support::Middleware::StackBuilder.new(name: name)
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
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_before(index_or_concern, concern)
              plain_stack.insert_before cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_after(index_or_concern, concern)
              plain_stack.insert_after cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_before_each(concern)
              plain_stack.insert_before_each cast(concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def insert_after_each(concern)
              plain_stack.insert_after_each cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def replace(index_or_concern, concern)
              plain_stack.replace cast(index_or_concern), cast(concern)

              self
            end

            ##
            # @param index_or_concern [Integer, ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def delete(index_or_concern)
              plain_stack.delete cast(index_or_concern)

              self
            end

            ##
            # @param concern [ConvenientService::Support::Concern, Module]
            # @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
            #
            def use(concern)
              plain_stack.use cast(concern)

              self
            end

            ##
            # @return [Boolean]
            #
            def empty?
              to_a.empty?
            end

            ##
            # @return [Array]
            #
            def to_a
              plain_stack.to_a
            end

            ##
            # @param other [ConvenientService::Core::Entities::Concerns::Entities::Stack, Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if plain_stack != other.plain_stack

              true
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
