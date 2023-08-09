# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnNotResultReturnValue
        class Middleware < MethodChainMiddleware
          include Support::DependencyContainer::Import

          import :"commands.is_result?", from: Service::Plugins::HasJSendResult::Container

          intended_for any_method, entity: :service

          def next(...)
            original_result = chain.next(...)

            return original_result if commands.is_result?(original_result)

            raise Exceptions::ReturnValueNotKindOfResult.new(service: entity, result: original_result, method: method)
          end
        end
      end
    end
  end
end
