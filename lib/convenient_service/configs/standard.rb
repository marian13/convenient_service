# frozen_string_literal: true

module ConvenientService
  module Configs
    module Standard
      include Support::Concern

      ##
      # IMPORTANT: Order of plugins matters.
      #
      # NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
      # That is why `class self::Result` is used.
      #
      # https://stackoverflow.com/a/51965126/12201472
      #
      # rubocop:disable Lint/ConstantDefinitionInBlock
      included do
        include Core

        concerns do
          use Plugins::Common::HasInternals::Concern
          use Plugins::Common::HasConstructor::Concern

          use Plugins::Common::CachesConstructorParams::Concern
          use Plugins::Common::CanBeCopied::Concern
          use Plugins::Service::HasResult::Concern
          use Plugins::Service::CanAdjustForeignResults::Concern
          use Plugins::Service::HasResultShortSyntax::Concern
          use Plugins::Service::HasResultSteps::Concern
          use Plugins::Service::CanRecalculateResult::Concern

          use Plugins::Common::HasCallbacks::Concern
          use Plugins::Common::HasAroundCallbacks::Concern

          ##
          # NOTE: Optional plugins.
          # TODO: Specs.
          #
          #   use Plugins::Common::HasConfig::Concern
          #
        end

        middlewares :initialize do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Common::CachesConstructorParams::Middleware
        end

        middlewares :result do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResult::Middleware

          use Plugins::Service::HasResultSteps::Middleware

          use Plugins::Common::HasCallbacks::Middleware
          use Plugins::Common::HasAroundCallbacks::Middleware

          use Plugins::Service::RaisesOnDoubleResult::Middleware

          use Plugins::Common::CachesReturnValue::Middleware
        end

        middlewares :success do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Success::Middleware
        end

        middlewares :failure do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Failure::Middleware
        end

        middlewares :error do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Error::Middleware
        end

        middlewares :step, scope: :class do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultMethodSteps::Middleware
        end

        class self::Internals
          include Core

          concerns do
            use Plugins::Internals::HasCache::Concern
          end
        end

        class self::Result
          include Core

          concerns do
            use Plugins::Common::HasInternals::Concern

            use Plugins::Result::HasResultShortSyntax::Concern
            use Plugins::Result::CanRecalculateResult::Concern
          end

          middlewares :success? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :failure? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :error? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_success? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_failure? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_error? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :data do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :message do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :code do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          class self::Internals
            include Core

            concerns do
              use Plugins::Internals::HasCache::Concern
            end
          end
        end

        class self::Step
          include Core

          concerns do
            use Plugins::Common::HasInternals::Concern
          end

          middlewares :result do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Common::CachesReturnValue::Middleware
          end

          class self::Internals
            include Core

            concerns do
              use Plugins::Internals::HasCache::Concern
            end
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end
