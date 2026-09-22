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
          def next(...)
            result = chain.next(...)

            return result if Service::Plugins::HasJSendResult.result?(result)

            ::ConvenientService.raise Exceptions::ReturnValueNotKindOfResult.new(service: entity, result: result, method: method)
          end
        end
      end
    end
  end
end
