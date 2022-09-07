# frozen_string_literal: true

module ConvenientService
  module Configs
    module HasResultParamsValidations
      module UsingDryValidation
        include Support::Concern

        included do
          include Core

          concerns do
            use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Concern
          end

          middlewares for: :result do
            use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Middleware
          end
        end
      end
    end
  end
end
