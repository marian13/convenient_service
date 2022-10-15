# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        module Services
          module MethodStepConfig
            include Support::Concern

            included do
              include Core

              concerns do
                use Service::Plugins::HasResult::Concern
              end

              middlewares :result do
                use Common::Plugins::NormalizesEnv::Middleware

                use Service::Plugins::HasResult::Middleware
              end
            end
          end
        end
      end
    end
  end
end
