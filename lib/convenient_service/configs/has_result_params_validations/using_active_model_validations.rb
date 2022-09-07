# frozen_string_literal: true

module ConvenientService
  module Configs
    module HasResultParamsValidations
      module UsingActiveModelValidations
        include Support::Concern

        included do
          include Core

          concerns do
            use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Concern
          end

          middlewares for: :result do
            use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Middleware
          end
        end
      end
    end
  end
end
