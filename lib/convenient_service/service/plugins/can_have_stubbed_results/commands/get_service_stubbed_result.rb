# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Commands
          class GetServiceStubbedResult < Support::Command
            ##
            # @!attribute [r] service
            #   @return [ConvenientService::Service]
            #
            attr_reader :service

            ##
            # @!attribute [r] arguments
            #   @return [ConvenientService::Support::Arguments]
            #
            attr_reader :arguments

            ##
            # @param service [ConvenientService::Service]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [void]
            #
            def initialize(service:, arguments:)
              @service = service
              @arguments = arguments
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            #
            def call
              cache.read(key)
            end

            private

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def cache
              @cache ||= Commands::FetchServiceStubbedResultsCache.call(service: service)
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Key]
            #
            def key
              @key ||= cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block)
            end
          end
        end
      end
    end
  end
end
