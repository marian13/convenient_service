# frozen_string_literal: true

module ConvenientService
  module Configs
    module Rails
      include Support::Concern

      included do
        include Configs::Standard

        concerns do
          use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
          use Plugins::Common::HasAttributes::Concern
          use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Concern
        end

        middlewares for: :initialize do
          use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
        end

        middlewares for: :result do
          use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Middleware

          ##
          # NOTE: Optional plugins.
          # TODO: Specs.
          #
          #   use Plugins::Service::WrapsResultInDbTransaction::Middleware
          #
        end
      end
    end
  end
end
