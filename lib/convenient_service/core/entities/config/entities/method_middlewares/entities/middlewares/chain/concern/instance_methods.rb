# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Chain < Middlewares::Base
                  module Concern
                    module InstanceMethods
                      include Support::AbstractMethod

                      ##
                      # @return [Object] Can be any type.
                      # @raise [ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden] if NOT overridden in descendant.
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
                      # @param env [Hash]
                      # @return [Object] Can be any type.
                      #
                      def call(env)
                        @__env__ = Commands::NormalizeEnv.call(env: env)

                        ##
                        # IMPORTANT: This is a library code. Do NOT do things like this in your application code.
                        #
                        chain.instance_variable_set(:@env, @__env__)

                        ##
                        # NOTE: `__send__` is used since `next` is ruby keyword.
                        # https://ruby-doc.org/core-2.7.0/doc/keywords_rdoc.html
                        #
                        # TODO: Enforce to always pass args, kwargs, block.
                        #
                        __send__(:next, *@__env__[:args], **@__env__[:kwargs], &@__env__[:block])
                      end

                      ##
                      # @return [Class, Object]
                      #
                      # @internal
                      #   NOTE: `@__env__` is set inside `call`.
                      #
                      def entity
                        @__env__[:entity]
                      end

                      ##
                      # @return [Symbol]
                      #
                      # @note Fallback to avoid `if` conditions based on `method` value when possible, prefer to create separate middlewares instead.
                      #
                      # @internal
                      #   NOTE: `@__env__` is set inside `call`.
                      #
                      def method
                        @__env__[:method]
                      end

                      ##
                      # @return [ConvenientService::Support::Arguments]
                      #
                      # @internal
                      #   NOTE: `@__env__` is set inside `call`.
                      #   NOTE: `@__env__[:args]` is set in `ConvenientService::Common::Plugins::NormalizesEnv::Middleware`.
                      #
                      def next_arguments
                        return unless @__env__.has_key?(:args)

                        @__next_arguments__ ||= Support::Arguments.new(*@__env__[:args], **@__env__[:kwargs], &@__env__[:block])
                      end

                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Chain]
                      #
                      # @internal
                      #   NOTE: `@__env__` is set inside `call`.
                      #
                      def chain
                        @__chain__ ||= self.class.chain_class.new(stack: @__stack__)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
