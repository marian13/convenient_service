# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
#   ConvenientService::Examples::Rails::V1::Gemfile::Services::AssertNpmPackageAvailable.result(name: "lodash")
#
module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          module Services
            class AssertNpmPackageAvailable
              include RailsService::Config

              attribute :name, :string

              validates :name, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

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
