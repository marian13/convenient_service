# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        module V1
          include ConvenientService::Config

          available_options do
            [
              :essential,
              :callbacks,
              :inspect,
              :recalculation,
              :result_parents_trace,
              :code_review_automation,
              :short_syntax,
              :type_safety,
              :exception_services_trace,
              :per_instance_caching,
              :backtrace_cleaner,
              :rspec
            ]
          end

          default_options do
            [
              :essential,
              :callbacks,
              :inspect,
              :recalculation,
              :result_parents_trace,
              :code_review_automation,
              :short_syntax,
              :type_safety,
              :exception_services_trace,
              :per_instance_caching,
              :backtrace_cleaner,
              rspec: Dependencies.rspec.loaded?
            ]
          end

          ##
          # @internal
          #   IMPORTANT: Order of plugins matters.
          #
          #   NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
          #   That is why `entity :Result do` is used.
          #   - https://stackoverflow.com/a/51965126/12201472
          #
          # rubocop:disable Lint/ConstantDefinitionInBlock
          included do
            include ConvenientService::Standard::Config
              .without_defaults
              .with(options)

            concerns do
              if options.enabled?(:essential)
                replace \
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Concern,
                  ConvenientService::Plugins::Service::CanHaveSequentialSteps::Concern
              end
            end

            middlewares :result do
              if options.enabled?(:essential)
                replace \
                  ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware,
                  ConvenientService::Plugins::Service::CanHaveSequentialSteps::Middleware
              end

              if options.enabled?(:active_model_validations)
                replace \
                  ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware,
                  ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware.with(status: :failure)
              end
            end
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock
        end
      end
    end
  end
end
