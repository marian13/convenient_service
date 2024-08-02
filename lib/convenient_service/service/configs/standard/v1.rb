# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        module V1
          include ConvenientService::Config

          ##
          # @internal
          #   IMPORTANT: Order of plugins matters.
          #
          #   NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
          #   That is why `class self::Result` is used.
          #   - https://stackoverflow.com/a/51965126/12201472
          #
          # rubocop:disable Lint/ConstantDefinitionInBlock
          included do
            include ConvenientService::Core

            include Configs::Essential

            include Configs::Callbacks
            include Configs::Inspect
            include Configs::Recalculation
            include Configs::ResultParentsTrace
            include Configs::RSpec

            include Configs::CodeReviewAutomation
            include Configs::ShortSyntax

            concerns do
              use ConvenientService::Plugins::Service::HasMermaidFlowchart::Concern

              replace \
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Concern,
                ConvenientService::Plugins::Service::CanHaveSequentialSteps::Concern
            end

            middlewares :initialize do
              use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            end

            middlewares :result do
              unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware

              ##
              # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
              #
              # use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware

              replace \
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware,
                ConvenientService::Plugins::Service::CanHaveSequentialSteps::Middleware
            end
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock
        end
      end
    end
  end
end
