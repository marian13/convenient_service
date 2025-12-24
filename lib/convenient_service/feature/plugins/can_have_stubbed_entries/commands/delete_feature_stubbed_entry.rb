# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        module Commands
          class DeleteFeatureStubbedEntry < Support::Command
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
            # @param feature [ConvenientService::Feature]
            # @param entry [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [void]
            #
            def initialize(feature:, entry:, arguments:)
              @feature = feature
              @entry = entry
              @arguments = arguments
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `arguments.nil?` means "match any arguments".
            #
            def call
              if arguments.nil?
                cache.default = nil
              else
                cache.delete(cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block))
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
