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
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
