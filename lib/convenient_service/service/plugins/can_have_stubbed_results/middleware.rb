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
            return cache[key_with_arguments] if cache.exist?(key_with_arguments)
            return cache[key_without_arguments] if cache.exist?(key_without_arguments)

            chain.next(...)
          end

          private

          ##
          # @return [ConvenientService::Support::Cache]
          #
          def cache
            @cache ||= entity.stubbed_results
          end

          ##
          # @return [ConvenientService::Support::Cache::Entities::Key]
          #
          def key_with_arguments
            @key_with_arguments ||= cache.keygen(*next_arguments.args, **next_arguments.kwargs, &next_arguments.block)
          end

          ##
          # @return [ConvenientService::Support::Cache::Entities::Key]
          #
          def key_without_arguments
            @key_without_arguments ||= cache.keygen
          end
        end
      end
    end
  end
end
