# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
            include ConvenientService::Config

            included do
              include ConvenientService::Standard::Config.with(:dry_initializer)

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
