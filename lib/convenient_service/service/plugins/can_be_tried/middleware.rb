# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanBeTried
        class Middleware < MethodChainMiddleware
          intended_for :try_result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          # @internal
          #   NOTE: Copy is returned to have a fresh status.
          #
          def next(...)
            try_result = chain.next(...)

            raise Errors::ServiceTryReturnValueNotSuccess.new(service: entity, result: try_result) unless try_result.success?

            try_result.copy(overrides: {kwargs: {try_result: true}})
          end
        end
      end
    end
  end
end
