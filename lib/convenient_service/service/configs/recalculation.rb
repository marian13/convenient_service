# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Recalculation
        include Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          concerns do
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Concern
            use ConvenientService::Plugins::Common::CanBeCopied::Concern
            use ConvenientService::Plugins::Service::CanRecalculateResult::Concern
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Middleware
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::CanRecalculateResult::Concern
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
