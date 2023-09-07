# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        class Middleware < MethodChainMiddleware
          intended_for [:fallback_failure_result, :fallback_error_result], entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @note Both `fallback_failure_result` and `fallback_error_result` are always successful, that is why their statuses are pre-checked.
          #
          def next(...)
            fallback_result = chain.next(...)

            raise Exceptions::ServiceFallbackReturnValueNotSuccess.new(service: entity, result: fallback_result, status: status) unless fallback_result.success?

            fallback_result.copy(overrides: {kwargs: {method => true}})
              .tap { |result| result.success? }
          end

          private

          ##
          # @return [Symbol]
          #
          def status
            middleware_arguments.kwargs.fetch(:status)
          end
        end
      end
    end
  end
end
