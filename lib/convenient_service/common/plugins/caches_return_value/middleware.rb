# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        class Middleware < Core::MethodChainMiddleware
          def next(*args, **kwargs, &block)
            key = Entities::Key.new(method: method, args: args, kwargs: kwargs, block: block)

            entity.internals.cache.fetch(key) { chain.next(*args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
