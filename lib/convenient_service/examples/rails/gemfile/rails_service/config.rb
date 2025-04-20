# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Rails::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      class Gemfile
        class RailsService
          module Config
            include ConvenientService::Config

            included do
              include ConvenientService::Standard::Config.with(:active_model_validations)

              ##
              # NOTE: `AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment` plugin.
              #
              concerns do
                use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
              end

              middlewares :initialize do
                use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
              end

              ##
              # NOTE: `HasAttributes::UsingActiveModelAttributes` plugin.
              #
              concerns do
                use ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
              end
            end
          end
        end
      end
    end
  end
end
