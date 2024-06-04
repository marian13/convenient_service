# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CountsResultResolutionsInvocations
        class Middleware < MethodChainMiddleware
          intended_for [:success, :failure, :error], entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            chain.next(...)
              .tap { entity.result_resolutions_counter.increment! }
          end
        end
      end
    end
  end
end
