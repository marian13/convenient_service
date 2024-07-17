# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service]
          #
          alias_method :service, :entity

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            service.steps.any? ? service.steps_result(...) : service.regular_result(...)
          end
        end
      end
    end
  end
end
