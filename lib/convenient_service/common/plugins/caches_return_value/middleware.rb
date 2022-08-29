# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        class Middleware < Core::MethodChainMiddleware
          ##
          # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
          #
          #   def next(...)
          #     # ...
          #
          #     entity.internals.cache.fetch(key) { chain.next(...) }
          #   end
          #
          def next(*args, **kwargs, &block)
            key = Entities::Key.new(method: method, args: args, kwargs: kwargs, block: block)

            entity.internals.cache.fetch(key) { chain.next(*args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
