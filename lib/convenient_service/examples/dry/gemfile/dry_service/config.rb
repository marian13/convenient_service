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
      module Gemfile
        class DryService
          module Config
            def self.included(service_class)
              service_class.class_exec do
                include Configs::StandardUncommitted

                ##
                # NOTE: `AssignsAttributesInConstructor::UsingDryInitializer` plugin.
                #
                concerns do
                  use Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern
                end

                ##
                # NOTE: `HasResultParamsValidations::UsingDryValidation` plugin.
                #
                concerns do
                  use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Concern
                end

                middlewares for: :result do
                  use Plugins::Service::HasResultParamsValidations::UsingDryValidation::Middleware
                end

                commit_config!
              end
            end
          end
        end
      end
    end
  end
end
