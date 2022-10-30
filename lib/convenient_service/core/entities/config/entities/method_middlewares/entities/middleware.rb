# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              ##
              # @abstract Subclass and override `#next`.
              #
              # @internal
              #   NOTE: Do NOT pollute the interface of this class until really needed.
              #   Avoid even pollution of private methods.
              #   This way there is a lower risk that a plugin developer accidentally overwrites an internal middleware behavior.
              #   https://github.com/Ibsciss/ruby-middleware#a-basic-example
              #
              class Middleware
                include Support::AbstractMethod

                ##
                # @return [Object] Can be any type.
                # @raise [ConvenientService::Support::AbstractMethod::Errors::AbstractMethodNotOverridden] if NOT overridden in descendant.
                #
                # @example Subclass should call `value = chain.next(*args, **kwargs, &block)` to trigger next middleware in a stack.
                #   def next(*args, **kwargs, &block)
                #     # pre processing...
                #
                #     value = chain.next(*args, **kwargs, &block)
                #
                #     # post processing...
                #
                #     post_processed_value
                #   end
                #
                # @see https://refactoring.guru/design-patterns/decorator
                #
                # @note But it completely OK, to omit `chain.next(*args, **kwargs, &block)` completely.
                #   This way middleware stack is stopped in the "middle" and its "middle" value is returned.
                # @see https://refactoring.guru/design-patterns/proxy
                # @see https://refactoring.guru/design-patterns/chain-of-responsibility
                #
                abstract_method :next

                ##
                # @param stack [#call<Hash>]
                # @return [void]
                #
                def initialize(stack, env: {})
                  @stack = stack
                  @env = env
                end

                ##
                # @param env [Hash]
                # @return [Object] Can be any type.
                #
                def call(env)
                  @env = env

                  ##
                  # IMPORTANT: This is a library code. Do NOT do things like this in your application code.
                  #
                  chain.instance_variable_set(:@env, env)

                  ##
                  # NOTE: `__send__` is used since `next` is ruby keyword.
                  # https://ruby-doc.org/core-2.7.0/doc/keywords_rdoc.html
                  #
                  # TODO: Enforce to always pass args, kwargs, block.
                  #
                  __send__(:next, *env[:args], **env[:kwargs], &env[:block])
                end

                ##
                # @return [Class, Object]
                #
                # @internal
                #   NOTE: `@env` is set inside `call`.
                #
                def entity
                  @env[:entity]
                end

                ##
                # @return [Symbol]
                #
                # @note Try to avoid `if` conditions based on `method` value when possible, prefer to create separate middlewares instead.
                #
                # @internal
                #   NOTE: `@env` is set inside `call`.
                #
                def method
                  @env[:method]
                end

                ##
                # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Chain]
                #
                # @internal
                #   NOTE: `@env` is set inside `call`.
                #
                def chain
                  @chain ||= Entities::Chain.new(stack: @stack)
                end
              end
            end
          end
        end
      end
    end
  end
end
