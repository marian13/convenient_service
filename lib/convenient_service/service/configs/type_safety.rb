# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module TypeSafety
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :result do
            insert_before \
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
              ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
          end

          class self::Step
            include ConvenientService::Core

            middlewares :result do
              insert_before \
                ConvenientService::Plugins::Step::CanBeServiceStep::Middleware,
                ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware
            end
          end

          if include? Configs::Fallbacks
            middlewares :fallback_failure_result do
              insert_before \
                ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure),
                ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            end

            middlewares :fallback_error_result do
              insert_before \
                ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error),
                ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            end

            middlewares :fallback_result do
              insert_before \
                ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: nil),
                ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
