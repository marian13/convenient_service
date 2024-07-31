# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module CodeReviewAutomation
        include Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Service::CanNotBeInherited::Concern
          end

          middlewares :initialize do
            use ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware
          end

          class self::Result
            concerns do
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
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
