# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Services
          module MethodStepConfig
            include Support::Concern

            # rubocop:disable Lint/ConstantDefinitionInBlock
            included do
              include ConvenientService::Core

              concerns do
                use ConvenientService::Service::Plugins::HasResult::Concern
              end

              middlewares :result do
                use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                use ConvenientService::Service::Plugins::HasResult::Middleware
              end

              class self::Result
                include ConvenientService::Core

                concerns do
                  use ConvenientService::Common::Plugins::HasInternals::Concern
                  use ConvenientService::Common::Plugins::HasConstructor::Concern
                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

                  use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
                end

                class self::Internals
                  include ConvenientService::Core

                  concerns do
                    use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                  end
                end
              end
            end
            # rubocop:enable Lint/ConstantDefinitionInBlock
          end
        end
      end
    end
  end
end
