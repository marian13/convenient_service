# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        class Middleware < Core::MethodChainMiddleware
          ##
          # @param args [Array]
          # @param kwargs [Hash]
          # @param block [Proc]
          # @return [Object] Can be any type.
          #
          def next(*args, **kwargs, &block)
            (entity.internals.cache[:return_values] ||= Support::Cache.new)
              .fetch(Support::Cache.key(method, *args, **kwargs, &block)) { chain.next(*args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
