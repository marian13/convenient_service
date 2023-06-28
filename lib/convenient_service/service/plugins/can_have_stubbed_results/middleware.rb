# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        class Middleware < MethodChainMiddleware
          intended_for :result, scope: any_scope, entity: :service

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
            @cache ||= Utils::Object.clamp_class(entity).stubbed_results
          end

          ##
          # @return [ConvenientService::Support::Cache::Entities::Key]
          #
          # @internal
          #   NOTE: When middleware is used for a class, it takes arguments from class `result` method. For example:
          #
          #     # `next_arguments`.
          #     result = Service.result(*args, **kwargs, &block)
          #
          #   NOTE: When middleware is used for an instance, it takes arguments from class `new` method. For example:
          #
          #     # `entity.constructor_arguments`.
          #     service = Service.new(*args, **kwargs, &block)
          #     result = service.result
          #
          #   TODO: Think about two separate middlewares with shared commands.
          #
          def key_with_arguments
            @key_with_arguments ||=
              if entity.instance_of?(::Class)
                cache.keygen(*next_arguments.args, **next_arguments.kwargs, &next_arguments.block)
              else
                cache.keygen(*entity.constructor_arguments.args, **entity.constructor_arguments.kwargs, &entity.constructor_arguments.block)
              end
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
