# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [ConvenientService::Support::Cache]
            #
            def stubbed_results
              ::Thread.current[:__convenient_service_stubbed_results__].scope(self)
            end
          end
        end
      end
    end
  end
end
