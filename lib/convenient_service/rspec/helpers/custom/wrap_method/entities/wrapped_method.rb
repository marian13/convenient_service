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
            # NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
            #
            class WrappedMethod
              ##
              # NOTE: `middlewares' are `MethodChainMiddleware' classes.
              #
              def initialize(entity:, method:, middlewares:)
                @entity = entity
                @method = method
                @middlewares = middlewares

                @stack = Support::Middleware::StackBuilder.new do |stack|
                  middlewares.each { |middleware| stack.use middleware }

                  ##
                  # NOTE: The following proc middleware is triggered only when `chain.next' is called from method chain middleware.
                  #
                  stack.use(
                    proc do |env|
                      ##
                      # TODO: Enforce to always pass args, kwargs, block.
                      #
                      entity.send(method, *env[:args], **env[:kwargs], &env[:block])
                        .tap { |value| @chain_value = value }
                        .tap { @chain_arguments = {args: env[:args], kwargs: env[:kwargs], block: env[:block]} }
                    end
                  )
                end
              end

              def call(*args, **kwargs, &block)
                @stack.call(entity: @entity, method: @method, args: args, kwargs: kwargs, block: block)
              end

              def chain_called?
                Utils::Bool.to_bool(defined? @chain_value)
              end

              def chain_value
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :value) unless chain_called?

                @chain_value
              end

              def chain_args
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :args) unless chain_called?

                @chain_arguments[:args]
              end

              def chain_kwargs
                raise Errors::ChainAttributePreliminaryAccess.new(attribute: :kwargs) unless chain_called?

                @chain_arguments[:kwargs]
              end

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
