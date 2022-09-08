# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::AssertNpmPackageAvailable.result(name: "lodash")
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertNpmPackageAvailable
            include ConvenientService::Configs::Standard

            include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
            include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
            include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

            attr_accessor :name

            validates :name, presence: true

            step Services::AssertNodeAvailable

            ##
            # NOTE: `> /dev/null 2>&1' is used to hide output.
            # https://unix.stackexchange.com/a/119650/394253
            #
            # NOTE: For `npm list' and its options docs, see
            # https://docs.npmjs.com/cli/v7/commands/npm-ls
            #
            step Services::RunShell, in: {command: -> { "npm list #{name} --depth=0 > /dev/null 2>&1" }}
          end
        end
      end
    end
  end
end
