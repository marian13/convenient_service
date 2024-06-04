# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module CodeReviewAutomation
        include Support::Concern

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Service::CountsResultResolutionsInvocations::Concern
          end

          middlewares :result do
            unshift ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware
          end

          middlewares :success do
            unshift ConvenientService::Plugins::Service::CountsResultResolutionsInvocations::Middleware
          end

          middlewares :failure do
            unshift ConvenientService::Plugins::Service::CountsResultResolutionsInvocations::Middleware
          end

          middlewares :error do
            unshift ConvenientService::Plugins::Service::CountsResultResolutionsInvocations::Middleware
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
