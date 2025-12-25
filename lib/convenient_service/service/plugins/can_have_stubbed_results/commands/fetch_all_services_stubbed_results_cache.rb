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
          class FetchAllServicesStubbedResultsCache < Support::Command
            ##
            # @!attribute [r] service
            #   @return [Class<ConvenientService::Service>]
            #
            attr_reader :service

            ##
            # @param service [Class<ConvenientService::Service>]
            # @return [void]
            #
            def initialize(service:)
              @service = service
            end

            ##
            # @return [ConvenientService::Support::Cache]
            #
            def call
              if service.stubbed_results_store
                Utils::Object.memoize_including_falsy_values(service.stubbed_results_store, :@__convenient_service_stubbed_results__) { Support::Cache.backed_by(:thread_safe_hash).new }
              else
                Support::Cache.backed_by(:thread_safe_hash).new
              end
            end
          end
        end
      end
    end
  end
end
