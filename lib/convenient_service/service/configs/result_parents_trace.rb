# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module ResultParentsTrace
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :result do
            insert_before \
              ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware,
              ConvenientService::Plugins::Service::SetsParentToForeignResult::Middleware
          end

          class self::Result
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Result::CanBeOwnResult::Concern
              use ConvenientService::Plugins::Result::CanHaveParentResult::Concern
            end
          end

          class self::Step
            include ConvenientService::Core

            middlewares :result do
              insert_after \
                ConvenientService::Plugins::Step::HasResult::Middleware,
                ConvenientService::Plugins::Step::CanHaveParentResult::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
