# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Dry::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Dry::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Dry
      class Gemfile
        class DryService
          module Config
            include Support::Concern

            included do
              include ConvenientService::Standard::Config

              ##
              # NOTE: `AssignsAttributesInConstructor::UsingDryInitializer` plugin.
              #
              concerns do
                use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern
              end

              ##
              # NOTE: `HasJSendResultParamsValidations::UsingDryValidation` plugin.
              #
              concerns do
                use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern
              end

              middlewares :result do
                insert_before \
                  ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
                  ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware
              end
            end
          end
        end
      end
    end
  end
end
