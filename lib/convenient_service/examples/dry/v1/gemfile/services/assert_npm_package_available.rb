# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertNpmPackageAvailable.result(name: "lodash")
#
module ConvenientService
  module Examples
    module Dry
      module V1
        class Gemfile
          module Services
            class AssertNpmPackageAvailable
              include DryService::Config

              option :name

              contract do
                schema do
                  required(:name).filled(:string)
                end
              end

              step Services::AssertNodeAvailable

              ##
              # NOTE: `> /dev/null 2>&1` is used to hide output.
              # https://unix.stackexchange.com/a/119650/394253
              #
              # NOTE: For `npm list` and its options docs, see
              # https://docs.npmjs.com/cli/v7/commands/npm-ls
              #
              step Services::RunShellCommand, in: {command: -> { "npm list #{name} --depth=0 > /dev/null 2>&1" }}
            end
          end
        end
      end
    end
  end
end
