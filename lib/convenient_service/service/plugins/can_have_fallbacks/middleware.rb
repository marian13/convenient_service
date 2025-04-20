# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallbacks
        class Middleware < MethodChainMiddleware
          intended_for [:fallback_failure_result, :fallback_error_result, :fallback_result], entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @note Both `fallback_failure_result`, `fallback_error_result` and `fallback_result` are always successful, that is why their statuses are pre-checked.
          #
          def next(...)
            fallback_result = chain.next(...)

            ::ConvenientService.raise Exceptions::ServiceFallbackReturnValueNotSuccess.new(service: entity, result: fallback_result, status: status) unless fallback_result.success?

            fallback_result.copy(overrides: {kwargs: {method => true}}).tap(&:success?)
          end

          private

          ##
          # @return [Symbol, nil]
          #
          def status
            middleware_arguments.kwargs.fetch(:status)
          end
        end
      end
    end
  end
end
