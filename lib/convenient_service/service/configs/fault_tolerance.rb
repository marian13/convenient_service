# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module FaultTolerance
        include Support::Concern

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
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
