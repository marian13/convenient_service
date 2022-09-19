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
        module RailsServiceConfig
          include Support::Concern

          included do
            include Configs::StandardUncommitted

            ##
            # NOTE: `AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment' plugin.
            #
            concerns do
              use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
            end

            middlewares for: :initialize do
              use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
            end

            ##
            # NOTE: `HasAttributes::UsingActiveModelAttributes' plugin.
            #
            concerns do
              use Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
            end

            ##
            # NOTE: `HasResultParamsValidations::UsingActiveModelValidations' plugin.
            #
            concerns do
              use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Concern
            end

            middlewares for: :result do
              use Plugins::Service::HasResultParamsValidations::UsingActiveModelValidations::Middleware
            end

            commit_config!
          end
        end
      end
    end
  end
end
