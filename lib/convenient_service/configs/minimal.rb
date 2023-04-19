# frozen_string_literal: true

module ConvenientService
  module Configs
    ##
    # Defines minimal configuration that adds a constructor, JSend-inspired result, steps, basic inspects, and internals to services.
    #
    # @note: This config is NOT intented for the end-user usage. Use `Standard` instead.
    #
    # @internal
    #   Heavily used in specs to test concerns and middlewares in isolation.
    #
    module Minimal
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
        include Core

        concerns do
          use Plugins::Common::HasInternals::Concern

          use Plugins::Service::HasInspect::Concern

          use Plugins::Common::HasConstructor::Concern
          use Plugins::Common::HasConstructorWithoutInitialize::Concern

          use Plugins::Service::HasResult::Concern
          use Plugins::Service::CanHaveSteps::Concern
        end

        middlewares :initialize do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :result do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResult::Middleware
          use Plugins::Service::CanHaveSteps::Middleware
        end

        middlewares :try_result do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :step do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :success do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :failure do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :error do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :result, scope: :class do
          use Plugins::Common::NormalizesEnv::Middleware
        end

        middlewares :step, scope: :class do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::CanHaveMethodSteps::Middleware
          use Plugins::Service::CanHaveResultStep::Middleware
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

            use Plugins::Result::HasInspect::Concern

            use Plugins::Common::HasConstructor::Concern

            use Plugins::Result::HasJSendStatusAndAttributes::Concern
          end

          middlewares :initialize do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::HasJSendStatusAndAttributes::Middleware
          end

          middlewares :success? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :ok? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :failure? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :error? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :not_success? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :not_ok? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :not_failure? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :not_error? do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :data do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :message do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :code do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :to_kwargs do
            use Plugins::Common::NormalizesEnv::Middleware
          end

          class self::Data
            include Core
          end

          class self::Message
            include Core
          end

          class self::Code
            include Core
          end

          class self::Status
            include Core
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

            use Plugins::Step::CanBeCompleted::Concern

            use Plugins::Step::HasInspect::Concern
          end

          middlewares :calculate_result do
            use Plugins::Common::NormalizesEnv::Middleware
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
