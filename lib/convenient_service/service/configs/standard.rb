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
        include Config

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
          include Configs::RSpec

          include Configs::CodeReviewAutomation
          include Configs::ShortSyntax

          concerns do
            use ConvenientService::Plugins::Service::HasMermaidFlowchart::Concern
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
          end

          middlewares :result do
            unshift ConvenientService::Plugins::Service::CollectsServicesInException::Middleware

            ##
            # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
            #
            # use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware

            insert_before \
              ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Plugins::Service::SetsParentToForeignResult::Middleware
          end

          middlewares :negated_result do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Common::EnsuresNegatedJSendResult::Middleware
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::HasNegatedResult::Concern
              use ConvenientService::Plugins::Result::CanBeOwnResult::Concern
              use ConvenientService::Plugins::Result::CanHaveParentResult::Concern
            end

            middlewares :negated_result do
              use ConvenientService::Plugins::Common::EnsuresNegatedJSendResult::Middleware
            end
          end

          class self::Step
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
