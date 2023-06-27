# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        class Middleware < MethodChainMiddleware
          ##
          # @internal
          #   TODO: `scope: any_type`.
          #
          intended_for :result, scope: :class, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          def next(...)
            key_with_arguments = cache.keygen(...)
            key_without_arguments = cache.keygen

            return cache[key_with_arguments] if cache.exist?(key_with_arguments)
            return cache[key_without_arguments] if cache.exist?(key_without_arguments)

            chain.next(...)
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
