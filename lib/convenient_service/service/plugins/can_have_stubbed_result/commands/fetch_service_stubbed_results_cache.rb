# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
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
              cache.scope(service)
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
