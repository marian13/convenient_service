# frozen_string_literal: true

module ConvenientService
  module Configs
    module Dry
      include Support::Concern

      included do
        include Configs::Standard

        concerns do
          use Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern
          use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Concern
        end

        middlewares for: :result do
          use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Middleware
        end
      end
    end
  end
end
