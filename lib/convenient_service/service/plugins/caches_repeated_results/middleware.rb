# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CachesRepeatedResults
        class Middleware < Core::MethodChainMiddleware
          ##
          # @api public
          # @param klass [Class]
          # @param args [Array]
          # @param kwargs [Hash]
          # @param block [Proc]
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          def next(klass, *args, **kwargs, &block)
            service = klass.new(*args, **kwargs, &block)

            entity.internals.cache[:repeated_results] ||= cache
            service.internals.cache[:repeated_results] = cache

            key = Support::Cache.key(klass, *args, **kwargs, &block)

            cache.fetch(key) { service.result }
          end

          private

          ##
          # @api private
          # @return [ConvenientService::Support::Cache]
          #
          def cache
            @cache ||= entity.internals.cache[:repeated_results] || Support::Cache.new
          end
        end
      end
    end
  end
end
