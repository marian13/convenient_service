# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        class Middleware < MethodChainMiddleware
          intended_for :result

          def next(...)
            original_result = chain.next(...)

            return original_result if Commands::IsResult.call(result: original_result)

            raise Errors::ServiceReturnValueNotKindOfResult.new(service: entity, result: original_result)
          end
        end
      end
    end
  end
end
