# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        module Commands
          class SetFeatureStubbedEntry < Support::Command
            ##
            # @!attribute [r] feature
            #   @return [ConvenientService::Feature]
            #
            attr_reader :feature

            ##
            # @!attribute [r] entry
            #   @return [Symbol, String]
            #
            attr_reader :entry

            ##
            # @!attribute [r] arguments
            #   @return [ConvenientService::Support::Arguments]
            #
            attr_reader :arguments

            ##
            # @!attribute [r] value
            #   @return [Object] Can be any type.
            #
            attr_reader :value

            ##
            # @param feature [ConvenientService::Feature]
            # @param entry [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @param value [Object] Can be any type.
            # @return [void]
            #
            def initialize(feature:, entry:, arguments:, value:)
              @feature = feature
              @entry = entry
              @arguments = arguments
              @value = value
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `arguments.nil?` means "match any arguments".
            #
            def call
              if arguments.nil?
                cache.default = value
              else
                cache.write(cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block), value)
              end
            end

            private

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def cache
              @cache ||= Commands::FetchFeatureStubbedEntriesCache.call(feature: feature).scope(entry.to_sym, backed_by: :thread_safe_array)
            end
          end
        end
      end
    end
  end
end
