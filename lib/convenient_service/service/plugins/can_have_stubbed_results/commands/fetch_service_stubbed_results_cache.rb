# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Commands
          class FetchServiceStubbedResultsCache < Support::Command
            ##
            # @!attribute [r] service
            #   @return [ConvenientService::Service]
            #
            attr_reader :service

            ##
            # @param service [ConvenientService::Service]
            # @return [void]
            #
            def initialize(service:)
              @service = service
            end

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def call
              cache.scope(service, backed_by: :thread_safe_array)
            end

            private

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def cache
              @cache ||= Commands::FetchAllServicesStubbedResultsCache.call
            end
          end
        end
      end
    end
  end
end
