# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      ##
      # Defines essential configuration that adds a constructor, JSend-inspired result, steps, basic inspects, and internals to services.
      #
      # @note This config is NOT intented for the end-user usage. Use `Standard` instead.
      #
      # @internal
      #   NOTE: Heavily used in specs to test concerns and middlewares in isolation.
      #
      module Essential
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

            use ConvenientService::Plugins::Common::HasConstructor::Concern
            use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern

            use ConvenientService::Plugins::Service::HasResult::Concern
            use ConvenientService::Plugins::Service::HasJSendResult::Concern

            use ConvenientService::Plugins::Service::HasNegatedResult::Concern
            use ConvenientService::Plugins::Service::HasNegatedJSendResult::Concern

            use ConvenientService::Plugins::Service::CanHaveSteps::Concern
            use ConvenientService::Plugins::Service::CanHaveConnectedSteps::Concern

            use ConvenientService::Plugins::Service::CanHaveFallbacks::Concern
          end

          middlewares :result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware

            use ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware
          end

          middlewares :step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          middlewares :not_step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          middlewares :and_step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          middlewares :and_not_step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          middlewares :or_step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          middlewares :or_not_step, scope: :class do
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

              use ConvenientService::Plugins::Common::HasConstructor::Concern
              use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern

              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Concern

              use ConvenientService::Plugins::Result::CanHaveStep::Concern
            end

            middlewares :initialize do
              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Middleware
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

              concerns do
                use ConvenientService::Plugins::Common::HasInternals::Concern
              end

              class self::Internals
                include Core

                concerns do
                  use ConvenientService::Plugins::Internals::HasCache::Concern
                end
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
            end

            ##
            # TODO: Simple debug for middlewares. For one service only.
            #
            middlewares :result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

              use ConvenientService::Plugins::Step::HasResult::Middleware

              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware

              use ConvenientService::Plugins::Step::CanBeMethodStep::CanBeExecuted::Middleware
            end

            ##
            # TODO: Rename.
            #
            middlewares :printable_service do
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
