# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanRecalculateResult
        module Concern
          include Support::Concern

          ##
          # NOTE: `CanRecalculateResult' plugin expects that `CanBeCopied' plugin is already included.
          # That is why `copy' method is available.
          #
          # NOTE: `CanRecalculateResult' plugin expects that `HasResult' plugin is already included.
          # That is why `result' method is available.
          #
          instance_methods do
            def recalculate_result
              copy.result
            end
          end
        end
      end
    end
  end
end
