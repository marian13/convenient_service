# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Commands
          class SetServiceStubbedResult < Support::Command
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
            # @!attribute [r] result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            attr_reader :result

            ##
            # @param service [ConvenientService::Service]
            # @param arguments [ConvenientService::Support::Arguments]
            # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @return [void]
            #
            def initialize(service:, arguments:, result:)
              @service = service
              @arguments = arguments
              @result = result
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def call
              cache.write(key, result)
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
