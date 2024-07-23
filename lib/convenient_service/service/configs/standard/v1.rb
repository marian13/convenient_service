# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        module V1
          include Support::Concern

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
            include Configs::Essential

            include Configs::Callbacks
            include Configs::Inspect
            include Configs::RSpec
            include Configs::ShortSyntax

            concerns do
              use ConvenientService::Plugins::Common::CachesConstructorArguments::Concern
              use ConvenientService::Plugins::Common::CanBeCopied::Concern
              use ConvenientService::Plugins::Service::CanRecalculateResult::Concern

              use ConvenientService::Plugins::Service::HasMermaidFlowchart::Concern

              delete ConvenientService::Plugins::Service::HasNegatedResult::Concern
              delete ConvenientService::Plugins::Service::HasNegatedJSendResult::Concern

              replace \
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Concern,
                ConvenientService::Plugins::Service::CanHaveSequentialSteps::Concern

              delete ConvenientService::Plugins::Service::CanHaveFallbacks::Concern
            end

            middlewares :initialize do
              use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
              use ConvenientService::Plugins::Common::CachesConstructorArguments::Middleware
            end

            middlewares :result do
              unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware

              ##
              # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
              #
              # use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware

              insert_before \
                ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
                ConvenientService::Plugins::Service::SetsParentToForeignResult::Middleware

              replace \
                ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware,
                ConvenientService::Plugins::Service::CanHaveSequentialSteps::Middleware
            end

            middlewares :step do
              use ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware
            end

            class self::Result
              concerns do
                use ConvenientService::Plugins::Result::CanRecalculateResult::Concern

                use ConvenientService::Plugins::Result::CanBeOwnResult::Concern
                use ConvenientService::Plugins::Result::CanHaveParentResult::Concern
                use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Concern
              end

              middlewares :data do
                use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
              end

              middlewares :message do
                use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
              end

              middlewares :code do
                use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
              end

              class self::Status
                concerns do
                  use ConvenientService::Plugins::Status::CanBeChecked::Concern
                end

                middlewares :success? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end

                middlewares :failure? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end

                middlewares :error? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end

                middlewares :not_success? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end

                middlewares :not_failure? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end

                middlewares :not_error? do
                  use ConvenientService::Plugins::Status::CanBeChecked::Middleware
                end
              end
            end

            class self::Step
              middlewares :result do
                use ConvenientService::Plugins::Step::CanHaveParentResult::Middleware
              end
            end
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock
        end
      end
    end
  end
end
