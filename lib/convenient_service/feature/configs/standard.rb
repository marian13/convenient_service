# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      ##
      # Default configuration for the user-defined features.
      #
      module Standard
        include Support::Concern

        included do
          include Core

          concerns do
            use ConvenientService::Plugins::Feature::CanHaveEntries::Concern
          end
        end
      end
    end
  end
end
