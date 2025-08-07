# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module RaisesOnNotResultReturnValue
                class Middleware < MethodChainMiddleware
                  intended_for any_method, entity: :step

                  def next(...)
                    original_result = chain.next(...)

                    return original_result if ConvenientService::Service::Plugins::HasJSendResult::Commands::IsResult[result: original_result]

                    ::ConvenientService.raise Exceptions::ReturnValueNotKindOfResult.new(step: entity, result: original_result)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
