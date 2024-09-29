# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      ##
      # Default configuration for the user-defined features.
      #
      module Standard
        include ConvenientService::Config

        included do
          include Configs::Essential
          include Configs::RSpec
        end
      end
    end
  end
end
