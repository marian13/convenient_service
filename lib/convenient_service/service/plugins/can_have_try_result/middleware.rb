# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveTryResult
        class Middleware < MethodChainMiddleware
          include Support::DependencyContainer::Import

          import "commands.is_result?", from: Service::Plugins::HasResult::Container

          intended_for :try_result

          ##
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          # @internal
          #   NOTE: Copy is returned to have a fresh status.
          #
          def next(...)
            try_result = chain.next(...)

            raise Errors::ServiceTryReturnValueNotKindOfResult.new(service: entity, result: try_result) unless commands.is_result?(try_result)
            raise Errors::ServiceTryReturnValueNotSuccess.new(service: entity, result: try_result) unless try_result.success?

            try_result.copy
          end
        end
      end
    end
  end
end
