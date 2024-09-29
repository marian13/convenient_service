# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      module Essential
        include ConvenientService::Config

        included do
          include Core

          concerns do
            use ConvenientService::Plugins::Feature::CanHaveEntries::Concern

            use ConvenientService::Plugins::Common::HasInstanceProxy::Concern
          end

          middlewares :new, scope: :class do
            use ConvenientService::Plugins::Common::HasInstanceProxy::Middleware
          end
        end
      end
    end
  end
end
