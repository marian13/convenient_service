# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        class Middleware < Core::MethodChainMiddleware
          def next(...)
            original_result = chain.next(...)

            return original_result if original_result.class.include?(Entities::Result::Concern)

            raise Errors::ServiceReturnValueNotKindOfResult.new(service: entity, result: original_result)
          end
        end
      end
    end
  end
end
