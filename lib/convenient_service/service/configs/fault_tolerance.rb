# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module FaultTolerance
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :result, scope: :class do
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          end

          middlewares :regular_result do
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          end

          middlewares :steps_result do
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          end

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Result::CanBeFromException::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
