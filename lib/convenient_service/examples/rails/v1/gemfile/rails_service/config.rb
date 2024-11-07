# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::V1::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Rails::V1::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          class RailsService
            module Config
              include ConvenientService::Config

              included do
                include ConvenientService::Standard::V1::Config.with(:active_model_validations)

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
end
