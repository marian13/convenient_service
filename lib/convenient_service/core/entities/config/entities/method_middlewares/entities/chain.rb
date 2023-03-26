# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              ##
              # @internal
              #   NOTE: Do NOT pollute the interface of this class until really needed.
              #
              class Chain
                ##
                # @param stack [#call<Hash>]
                # @param env [Hash]
                # @return [void]
                #
                def initialize(stack:, env: {})
                  @stack = stack
                  @env = env
                end

                ##
                # @param args [Array<Object>]
                # @param kwargs [Hash]
                # @param block [Proc]
                # @return [Object] Can be any type.
                #
                # @internal
                #   TODO: Enforce to always pass args, kwargs, block.
                #
                def next(*args, **kwargs, &block)
                  stack.call(env.merge(args: args, kwargs: kwargs, block: block))
                end

                ##
                # @param other [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Chain, Object]
                # @return [Boolean]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if stack != other.stack
                  return false if env != other.env

                  true
                end

                protected

                ##
                # @!attribute [r] stack
                #   @return [#call<Hash>]
                #
                attr_reader :stack

                ##
                # @!attribute [r] env
                #   @return [Hash]
                #
                attr_reader :env
              end
            end
          end
        end
      end
    end
  end
end
