# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Rollbacks
        include Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :result do
            insert_before \
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware,
              ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
