# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module ShortSyntax
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Concern
            use ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern
          end

          middlewares :success do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Success::Middleware
          end

          middlewares :failure do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Failure::Middleware
          end

          middlewares :error do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Error::Middleware
          end

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern
            end
          end

          class self::Step
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
