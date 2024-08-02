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
          include ConvenientService::Core

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

          middlewares :regular_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          middlewares :steps_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          class self::Internals
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Internals::HasCache::Concern
            end
          end

          class self::Result
            include ConvenientService::Core

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

            class self::Status
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Common::HasInternals::Concern
              end

              class self::Internals
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Plugins::Internals::HasCache::Concern
                end
              end
            end

            class self::Internals
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern
              end
            end
          end

          class self::Step
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Common::HasInternals::Concern

              use ConvenientService::Plugins::Step::HasResult::Concern

              use ConvenientService::Plugins::Step::CanBeCompleted::Concern

              use ConvenientService::Plugins::Step::CanBeServiceStep::Concern
              use ConvenientService::Plugins::Step::CanBeMethodStep::Concern
            end

            ##
            # TODO: Simple debug for middlewares. For one service only.
            #
            middlewares :result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

              use ConvenientService::Plugins::Step::HasResult::Middleware

              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware

              use ConvenientService::Plugins::Step::CanBeServiceStep::Middleware
              use ConvenientService::Plugins::Step::CanBeMethodStep::Middleware
            end

            middlewares :method_result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :service_result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            class self::Internals
              include ConvenientService::Core

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
