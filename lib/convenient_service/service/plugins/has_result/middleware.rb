# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        class Middleware < Core::MethodChainMiddleware
          def next(*args, **kwargs, &block)
            original_result = chain.next(*args, **kwargs, &block)

            return original_result if original_result.class.include?(Entities::Result::Concern)

            raise Errors::ServiceReturnValueNotKindOfResult.new(service: entity, result: original_result)
          end
        end
      end
    end
  end
end
