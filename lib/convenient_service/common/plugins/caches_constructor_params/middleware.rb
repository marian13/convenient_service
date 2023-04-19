# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorParams
        class Middleware < MethodChainMiddleware
          def next(*args, **kwargs, &block)
            entity.internals.cache[:constructor_params] = Entities::ConstructorParams.new(args: args, kwargs: kwargs, block: block)

            chain.next(*args, **kwargs, &block)
          end
        end
      end
    end
  end
end
