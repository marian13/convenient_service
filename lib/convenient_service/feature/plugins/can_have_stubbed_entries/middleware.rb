# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        class Middleware < MethodChainMiddleware
          intended_for :trigger, scope: any_scope, entity: :feature

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
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
            @cache ||= Utils::Object.clamp_class(entity).stubbed_entries.scope(entry_name)
          end

          ##
          # @return [Symbol]
          #
          def entry_name
            next_arguments.args[0]
          end

          ##
          # @return [ConvenientService::Support::Cache::Entities::Key]
          #
          def key_with_arguments
            @key_with_arguments ||= cache.keygen(*next_arguments.args[1..], **next_arguments.kwargs, &next_arguments.block)
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
