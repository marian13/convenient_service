# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        class Middleware < Core::MethodChainMiddleware
          def next(*args, **kwargs, &block)
            entity.callbacks.for([:before, method]).each { |callback| callback.call_in_context(entity) }

            original_value = chain.next(*args, **kwargs, &block)

            entity.callbacks.for([:after, method]).reverse_each { |callback| callback.call_in_context(entity, original_value) }

            original_value
          end
        end
      end
    end
  end
end
