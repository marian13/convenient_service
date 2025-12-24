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
          class DeleteServiceStubbedResult < Support::Command
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
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
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
              @cache ||= Commands::FetchServiceStubbedResultsCache.call(service: service)
            end
          end
        end
      end
    end
  end
end
