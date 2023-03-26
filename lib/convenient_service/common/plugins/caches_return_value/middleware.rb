# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        class Middleware < Core::MethodChainMiddleware
          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc]
          # @return [Object] Can be any type.
          #
          def next(*args, **kwargs, &block)
            key = cache.keygen(:return_values, method, *args, **kwargs, &block)

            cache.fetch(key) { chain.next(*args, **kwargs, &block) }
          end

          private

          ##
          # @return [ConvenientService::Support::Cache]
          #
          def cache
            @cache ||= entity.internals.cache
          end
        end
      end
    end
  end
end
