# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasNegatedJSendResult
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   TODO: Specs.
            #
            def negated_result
              original_result = result

              if original_result.success?(mark_status_as_checked: false)
                failure(message: "Original result is successful")
              elsif original_result.failure?(mark_status_as_checked: false)
                success(message: original_result.message)
              elsif original_result.error?(mark_status_as_checked: false)
                original_result.copy
              end
            end
          end
        end
      end
    end
  end
end
