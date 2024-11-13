# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        class Middleware < MethodChainMiddleware
          intended_for :trigger, scope: any_scope, entity: :feature

          ##
          # @return [Object] Can be any type.
          #
          def next(...)
            cache.read(key) || chain.next(...)
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
          def key
            @key ||= cache.keygen(*next_arguments.args[1..], **next_arguments.kwargs, &next_arguments.block)
          end
        end
      end
    end
  end
end
