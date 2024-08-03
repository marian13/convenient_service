# frozen_string_literal: true

require_relative "standard/v1"
require_relative "standard/aliases"

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        include ConvenientService::Config

        ##
        # @internal
        #   IMPORTANT: Order of plugins matters.
        #
        #   NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
        #   That is why `class self::Result` is used.
        #   - https://stackoverflow.com/a/51965126/12201472
        #
        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          include Configs::Callbacks
          include Configs::Fallbacks
          # include Configs::Rollbacks

          # include Configs::FaultTolerance
          include Configs::Inspect
          include Configs::Recalculation
          include Configs::ResultParentsTrace
          include Configs::RSpec

          include Configs::CodeReviewAutomation
          include Configs::ShortSyntax

          include Configs::ExceptionServicesTrace # Should be added after `Fallacks` config, when it is used.

          concerns do
            use ConvenientService::Plugins::Service::HasMermaidFlowchart::Concern
          end

          ##
          # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
          #
          # middlewares :result do
          #   use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware
          # end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
