# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Rails::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      module Gemfile
        class RailsService
          module Config
            def self.included(service_class)
              service_class.class_exec do
                include Configs::Standard

                ##
                # NOTE: `AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment` plugin.
                #
                concerns do
                  use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
                end

                middlewares :initialize do
                  use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
                end

                ##
                # NOTE: `HasAttributes::UsingActiveModelAttributes` plugin.
                #
                concerns do
                  use Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
                end

                ##
                # NOTE: `HasResultParamsValidations::UsingActiveModelValidations` plugin.
                #
                concerns do
                  use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Concern
                end

                middlewares :result do
                  insert_before \
                    Plugins::Service::HasResultSteps::Middleware,
                    Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Middleware
                end
              end
            end
          end
        end
      end
    end
  end
end
