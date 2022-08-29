# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      module Middlewares
        ##
        # https://github.com/Ibsciss/ruby-middleware#a-basic-example
        #
        # NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
        #
        class MethodChainMiddleware
          def initialize(stack)
            @stack = stack
          end

          def call(env)
            @env = env

            ##
            # IMPORTANT: This is a library code. Do NOT do things like this in your application code.
            #
            chain.instance_variable_set(:@env, env)

            ##
            # TODO: Enforce to always pass args, kwargs, block.
            #
            send(:next, *env[:args], **env[:kwargs], &env[:block])
          end

          ##
          # NOTE: `@env' is set inside `call'.
          #
          def entity
            @env[:entity]
          end

          ##
          # NOTE: `@env' is set inside `call'.
          #
          def method
            @env[:method]
          end

          ##
          # NOTE: `@env' is set inside `call'.
          #
          def chain
            @chain ||= Entities::Chain.new(stack: @stack)
          end

          ##
          # TODO: Unify `inspect'. Specs for `inspect'.
          #
          def inspect
            self.class.inspect
          end
        end
      end
    end
  end
end
