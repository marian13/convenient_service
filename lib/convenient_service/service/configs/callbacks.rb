# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Callbacks
        include Support::Concern

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Common::CanHaveCallbacks::Concern
          end

          middlewares :before, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveBeforeStepCallbacks::Middleware
          end

          middlewares :around, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveAroundStepCallbacks::Middleware
          end

          middlewares :after, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveAfterStepCallbacks::Middleware
          end

          middlewares :result do
            insert_after \
              ConvenientService::Plugins::Common::CachesReturnValue::Middleware,
              ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware
          end

          class self::Step
            concerns do
              use ConvenientService::Plugins::Common::CanHaveCallbacks::Concern
            end

            middlewares :result do
              insert_after \
                ConvenientService::Plugins::Common::CachesReturnValue::Middleware,
                ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
