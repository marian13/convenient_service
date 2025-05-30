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
          class FetchFeatureStubbedEntriesCache < Support::Command
            ##
            # @!attribute [r] feature
            #   @return [ConvenientService::Feature]
            #
            attr_reader :feature

            ##
            # @param feature [ConvenientService::Feature]
            # @return [void]
            #
            def initialize(feature:)
              @feature = feature
            end

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def call
              cache.scope(feature, backed_by: :thread_safe_hash)
            end

            private

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def cache
              @cache ||= Commands::FetchAllFeaturesStubbedEntriesCache.call
            end
          end
        end
      end
    end
  end
end
