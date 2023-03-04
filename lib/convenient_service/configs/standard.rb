# frozen_string_literal: true

module ConvenientService
  module Configs
    ##
    # Default configuration for the user-defined services.
    #
    module Standard
      include Support::Concern

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
        include Configs::Minimal

        concerns do
          use Plugins::Common::CachesConstructorParams::Concern
          use Plugins::Common::CanBeCopied::Concern
          use Plugins::Service::CanRecalculateResult::Concern
          use Plugins::Service::HasResultShortSyntax::Concern
          use Plugins::Service::HasResultStatusCheckShortSyntax::Concern

          use Plugins::Common::HasCallbacks::Concern
          use Plugins::Common::HasAroundCallbacks::Concern
        end

        middlewares :initialize do
          use Plugins::Common::CachesConstructorParams::Middleware
        end

        middlewares :result do
          insert_before \
            Plugins::Service::HasResult::Middleware,
            Plugins::Common::HasCallbacks::Middleware

          insert_after \
            Plugins::Common::HasCallbacks::Middleware,
            Plugins::Common::HasAroundCallbacks::Middleware

          use Plugins::Service::RaisesOnDoubleResult::Middleware

          use Plugins::Common::CachesReturnValue::Middleware
        end

        middlewares :step do
          use Plugins::Common::HasCallbacks::Middleware
          use Plugins::Common::HasAroundCallbacks::Middleware
        end

        middlewares :success do
          use Plugins::Service::HasResultShortSyntax::Success::Middleware
        end

        middlewares :failure do
          use Plugins::Service::HasResultShortSyntax::Failure::Middleware
        end

        middlewares :error do
          use Plugins::Service::HasResultShortSyntax::Error::Middleware
        end

        middlewares :step, scope: :class do
          use Plugins::Service::CanHaveMethodSteps::Middleware
        end

        class self::Result
          concerns do
            use Plugins::Result::HasResultShortSyntax::Concern
            use Plugins::Result::CanRecalculateResult::Concern

            use Plugins::Result::HasStep::Concern
            use Plugins::Result::CanHaveParentResult::Concern
          end

          middlewares :initialize do
            use Plugins::Result::HasStep::Initialize::Middleware
            use Plugins::Result::CanHaveParentResult::Initialize::Middleware
          end

          middlewares :success? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :failure? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :error? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_success? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_failure? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :not_error? do
            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares :data do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :message do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :code do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :to_kwargs do
            use Plugins::Result::HasStep::ToKwargs::Middleware
            use Plugins::Result::CanHaveParentResult::ToKwargs::Middleware
          end
        end

        class self::Step
          middlewares :calculate_result do
            use Plugins::Step::CanHaveParentResult::Middleware
          end
        end

        if Dependencies.rspec.loaded?
          concerns do
            insert_before 0, Plugins::Service::CanHaveStubbedResult::Concern
          end

          middlewares :result, scope: :class do
            insert_after \
              Plugins::Common::NormalizesEnv::Middleware,
              Plugins::Service::CanHaveStubbedResult::Middleware
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end
