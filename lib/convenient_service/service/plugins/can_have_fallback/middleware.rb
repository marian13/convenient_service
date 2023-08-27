# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        class Middleware < MethodChainMiddleware
          intended_for :fallback_result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @note `fallback_result` is always successful, that is why its status is pre-checked.
          #
          # @internal
          #   NOTE: Copy is returned to have a fresh status.
          #
          def next(...)
            fallback_result = chain.next(...)

            raise Exceptions::ServiceFallbackReturnValueNotSuccess.new(service: entity, result: fallback_result) unless fallback_result.success?

            fallback_result.copy(overrides: {kwargs: {fallback_result: true}})
              .tap { |result| result.success? }
          end
        end
      end
    end
  end
end
