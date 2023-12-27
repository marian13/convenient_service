# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module RaisesOnNotResultReturnValue
                class Middleware < MethodChainMiddleware
                  include Support::DependencyContainer::Import

                  import :"commands.is_result?", from: ::ConvenientService::Service::Plugins::HasJSendResult::Container

                  intended_for any_method, entity: :step

                  def next(...)
                    original_result = chain.next(...)

                    return original_result if commands.is_result?(original_result)

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
