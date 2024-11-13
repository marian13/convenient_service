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
            # @internal
            #   NOTE: `arguments.nil?` means "match any arguments".
            #
            def call
              if arguments.nil?
                cache.default = result
              else
                cache.write(cache.keygen(*arguments.args, **arguments.kwargs, &arguments.block), result)
              end
            end

            private

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def cache
              @cache ||= Commands::FetchServiceStubbedResultsCache.call(service: service)
            end
          end
        end
      end
    end
  end
end
