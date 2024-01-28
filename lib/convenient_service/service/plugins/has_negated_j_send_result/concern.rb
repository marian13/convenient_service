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
            # @note Users may override this method to provider custom `negataed_result` behavior.
            #
            def negated_result
              result.negated_result
            end
          end
        end
      end
    end
  end
end
