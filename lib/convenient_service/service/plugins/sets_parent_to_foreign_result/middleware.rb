# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module SetsParentToForeignResult
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @example Behavior when `SetsParentToForeignResult` middleware is NOT used.
          #
          #   class Service
          #     def result
          #       OtherService.result
          #     end
          #   end
          #
          #   service = Service.new
          #
          #   service.result
          #   # => Result.new(service: instance_of(OtherService), parent: instance_of(OtherService).parent)
          #
          # @example Behavior when `SetsParentToForeignResult` middleware is used.
          #
          #   class Service
          #     def result
          #       OtherService.result
          #     end
          #   end
          #
          #   service = Service.new
          #
          #   service.result
          #   # => Result.new(service: instance_of(Service), parent: instance_of(OtherService))
          #
          # @internal
          #   TODO: Document order of plugins.
          #
          #   NOTE: It is imposible to receive a foreign result from a step result, that is why `step: nil` is passed to `copy`. See `Step#result` for details.
          #
          #
          def next(...)
            result = chain.next(...)

            return result unless result.foreign_result_for?(entity)

            result.copy(overrides: {kwargs: {service: entity, step: nil, parent: result}})
          end
        end
      end
    end
  end
end
