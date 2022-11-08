# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        ##
        # TODO: Specs.
        #
        class WrapMethod < Support::Command
          module Entities
            ##
            # @internal
            #   TODO: A better name.
            #
            #   NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
            #
            class WrappedMethod
              ##
              # @param entity [Object, Class]
              # @param method [String]
              # @param middlewares [Array<ConvenientService::Core::MethodChainMiddleware>]
              # @return [void]
              #
              # @internal
              #   NOTE: `middlewares` are `MethodChainMiddleware` classes.
              #
              def initialize(entity:, method:, middlewares:)
                @entity = entity
                @method = method
                @middlewares = middlewares

                @stack = Support::Middleware::StackBuilder.new do |stack|
                  middlewares.each { |middleware| stack.use middleware }

                  ##
                  # NOTE: The following proc middleware is triggered only when `chain.next` is called from method chain middleware.
                  #
                  stack.use(
                    proc do |env|
                      entity.__send__(method, *env[:args], **env[:kwargs], &env[:block])
                        .tap { |value| @chain_value = value }
                        .tap { @chain_arguments = {args: env[:args], kwargs: env[:kwargs], block: env[:block]} }
                    end
                  )
                end
              end

              ##
              # @param args [Array]
              # @param kwargs [Hash]
              # @param block [Proc]
              # @return [Object] Can be any type.
              #
              def call(*args, **kwargs, &block)
                @stack.call(entity: @entity, method: @method, args: args, kwargs: kwargs, block: block)
              end

              ##
              # @return [void]
              #
              def reset!
                remove_instance_variable(:@chain_value) if defined? @chain_value
                remove_instance_variable(:@chain_arguments) if defined? @chain_arguments
              end

              ##
              # @return [Boolean]
              #
              def chain_called?
                Utils::Bool.to_bool(defined? @chain_value)
              end

              ##
              # @return [Object] Can be any type.
              #
              def chain_value
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :value) unless chain_called?

                @chain_value
              end

              ##
              # @return [Array]
              #
              def chain_args
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :args) unless chain_called?

                @chain_arguments[:args]
              end

              ##
              # @return [Hash]
              #
              def chain_kwargs
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :kwargs) unless chain_called?

                @chain_arguments[:kwargs]
              end

              ##
              # @return [Proc, nil]
              #
              def chain_block
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :block) unless chain_called?

                @chain_arguments[:block]
              end
            end
          end
        end
      end
    end
  end
end
