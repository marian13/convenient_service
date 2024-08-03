# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module ExceptionServicesTrace
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :initialize do
            unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
          end

          middlewares :result do
            unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
          end

          if include? Configs::Fallbacks
            middlewares :fallback_failure_result do
              unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            end

            middlewares :fallback_error_result do
              unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            end

            middlewares :fallback_result do
              unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
