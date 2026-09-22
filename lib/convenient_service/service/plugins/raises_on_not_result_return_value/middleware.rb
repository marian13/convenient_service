# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module RaisesOnNotResultReturnValue
        class Middleware < MethodChainMiddleware
          intended_for any_method, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          # @raise [ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult]
          #
          # @internal
          #   NOTE: When original result is a result duck and it has `NoMethodError` exception, that exception should be raised just like any other exception. See specs for details.
          #
          def next(...)
            result_duck = chain.next(...)

            begin
              result = result_duck.result
            rescue ::NoMethodError => exception
              raise exception if result_duck.respond_to?(:result)

              ::ConvenientService.raise Exceptions::ReturnValueNotKindOfResult.new(service: entity, result: result_duck, method: method)
            end

            return result if Service::Plugins::HasJSendResult.result?(result)

            ::ConvenientService.raise Exceptions::ReturnValueNotKindOfResult.new(service: entity, result: result, method: method)
          end
        end
      end
    end
  end
end
