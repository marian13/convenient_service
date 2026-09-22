# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module ConvertsResultDuckToResult
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: any_entity

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @internal
          #   NOTE: When original result is a result duck and it has `NoMethodError` exception, that exception should be raised just like any other exception. See specs for details.
          #
          def next(...)
            result_duck = chain.next(...)

            begin
              result_duck.result
            rescue ::NoMethodError => exception
              raise exception if result_duck.respond_to?(:result)

              result_duck
            end
          end
        end
      end
    end
  end
end
