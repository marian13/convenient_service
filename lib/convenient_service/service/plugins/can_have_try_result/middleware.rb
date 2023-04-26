# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveTryResult
        class Middleware < MethodChainMiddleware
          include Support::DependencyContainer::Import

          import "commands.is_result?", from: Service::Plugins::HasResult::Container

          intended_for :try_result

          def next(...)
            original_try_result = chain.next(...)

            raise Errors::ServiceTryReturnValueNotKindOfResult.new(service: entity, result: original_try_result) unless commands.is_result?(original_try_result)
            raise Errors::ServiceTryReturnValueNotSuccess.new(service: entity, result: original_try_result) unless original_try_result.success?

            original_try_result
          end
        end
      end
    end
  end
end
