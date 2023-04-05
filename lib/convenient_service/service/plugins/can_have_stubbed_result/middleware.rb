# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
        class Middleware < Core::MethodChainMiddleware
          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [Object] Can be any type.
          #
          def next(*args, **kwargs, &block)
            key_with_arguments = cache.keygen(*args, **kwargs, &block)
            key_without_arguments = cache.keygen

            return cache[key_with_arguments] if cache.exist?(key_with_arguments)
            return cache[key_without_arguments] if cache.exist?(key_without_arguments)

            chain.next(*args, **kwargs, &block)
          end

          private

          ##
          # @return [ConvenientService::Support::Cache]
          #
          def cache
            entity.stubbed_results
          end
        end
      end
    end
  end
end
