# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      ##
      # Defines minimal configuration that adds a constructor, JSend-inspired result, steps, basic inspects, and internals to services.
      #
      # @note This config is NOT intented for the end-user usage. Use `Standard` instead.
      #
      # @note
      #   `use ConvenientService::Plugins::Common::NormalizesEnv::Middleware` should be used in a config that has the first `concern` that introduces a method.
      #   For example, `:result` is added by `use ConvenientService::Plugins::Service::HasJSendResult::Concern` in `Minimal`.
      #   That is why the following code is written in the `Minimal` config.
      #
      #     middlewares :result do
      #       use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
      #
      #       # ...
      #     end
      #
      #   In turn, `:fallback_result` is added by `use ConvenientService::Plugins::Service::CanHaveFallbacks::Concern` in `Standard`.
      #   That is why it is the responsibility of the `Standard` config, to define:
      #
      #     middlewares :fallback_result do
      #       use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
      #
      #       # ...
      #     end
      #
      # @internal
      #   NOTE: Heavily used in specs to test concerns and middlewares in isolation.
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
            use ConvenientService::Plugins::Common::HasInternals::Concern

            use ConvenientService::Plugins::Service::HasInspect::Concern

            use ConvenientService::Plugins::Common::HasConstructor::Concern
            use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern

            use ConvenientService::Plugins::Service::HasResult::Concern
            use ConvenientService::Plugins::Service::HasJSendResult::Concern
            use ConvenientService::Plugins::Service::CanHaveSteps::Concern
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :result do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware

            use ConvenientService::Plugins::Service::CanHaveSteps::Middleware
          end

          middlewares :step do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :success do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :failure do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :error do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :result, scope: :class do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
          end

          middlewares :step, scope: :class do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware

            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          class self::Internals
            include Core

            concerns do
              use ConvenientService::Plugins::Internals::HasCache::Concern
            end
          end

          class self::Result
            include Core

            concerns do
              use ConvenientService::Plugins::Common::HasInternals::Concern

              use ConvenientService::Plugins::Result::HasInspect::Concern

              use ConvenientService::Plugins::Common::HasConstructor::Concern
              use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern

              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Concern

              use ConvenientService::Plugins::Result::CanHaveStep::Concern
            end

            middlewares :initialize do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware

              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Middleware
            end

            middlewares :success? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :failure? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :error? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :not_success? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :not_failure? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :not_error? do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :data do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :message do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :code do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            middlewares :to_kwargs do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            end

            class self::Data
              include Core

              concerns do
                use ConvenientService::Plugins::Data::HasInspect::Concern
              end
            end

            class self::Message
              include Core

              concerns do
                use ConvenientService::Plugins::Message::HasInspect::Concern
              end
            end

            class self::Code
              include Core

              concerns do
                use ConvenientService::Plugins::Code::HasInspect::Concern
              end
            end

            class self::Status
              include Core

              concerns do
                use ConvenientService::Plugins::Status::HasInspect::Concern
              end
            end

            class self::Internals
              include Core

              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern
              end
            end
          end

          class self::Step
            include Core

            concerns do
              use ConvenientService::Plugins::Common::HasInternals::Concern

              use ConvenientService::Plugins::Step::HasResult::Concern

              use ConvenientService::Plugins::Step::CanBeCompleted::Concern

              use ConvenientService::Plugins::Step::CanBeMethodStep::Concern
              use ConvenientService::Plugins::Step::CanBeResultStep::Concern

              use ConvenientService::Plugins::Step::HasInspect::Concern
            end

            ##
            # TODO: Move to `result`. Remove `service_result` middlewares completely.
            #
            middlewares :service_result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware

              use ConvenientService::Plugins::Step::CanBeResultStep::CanBeExecuted::Middleware
              use ConvenientService::Plugins::Step::CanBeMethodStep::CanBeExecuted::Middleware
            end

            middlewares :result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

              use ConvenientService::Plugins::Step::HasResult::Middleware
            end

            ##
            # TODO: Rename.
            #
            middlewares :printable_service do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware

              use ConvenientService::Plugins::Step::CanBeMethodStep::CanBePrinted::Middleware
            end

            class self::Internals
              include Core

              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern
              end
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
