# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasNegatedJSendResult
        class Middleware < MethodChainMiddleware
          intended_for :negated_result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            chain.next(...).copy(overrides: {kwargs: {negated: true}})
          end
        end
      end
    end
  end
end
