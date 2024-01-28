# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module EnsuresNegatedJSendResult
        class Middleware < MethodChainMiddleware
          intended_for :negated_result, entity: any_entity

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            result = chain.next(...)

            result.negated? ? result : result.copy(overrides: {kwargs: {negated: true}})
          end
        end
      end
    end
  end
end
