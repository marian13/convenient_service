# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module PerInstanceCaching
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :result do
            unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          middlewares :regular_result do
            unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          middlewares :steps_result do
            unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          middlewares :negated_result do
            unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
          end

          class self::Internals
            include ConvenientService::Core

            concerns do
              use ConvenientService::Plugins::Internals::HasCache::Concern
            end
          end

          class self::Result
            include ConvenientService::Core

            class self::Status
              include ConvenientService::Core

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

            middlewares :result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :method_result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :service_result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            class self::Internals
              include ConvenientService::Core

              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern
              end
            end
          end

          if include? Configs::Fallbacks
            middlewares :fallback_failure_result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :fallback_error_result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :fallback_result do
              unshift ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
