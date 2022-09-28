# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          ##
          # NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
          #
          class Chain
            def initialize(stack:, env: {})
              @stack = stack
              @env = env
            end

            ##
            # TODO: Enforce to always pass args, kwargs, block.
            #
            def next(*args, **kwargs, &block)
              @stack.call(@env.merge(args: args, kwargs: kwargs, block: block))
            end
          end
        end
      end
    end
  end
end
