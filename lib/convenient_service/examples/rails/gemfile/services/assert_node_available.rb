# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
#   ConvenientService::Examples::Rails::Gemfile::Services::AssertNodeAvailable.result
#
module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class AssertNodeAvailable
            include RailsService::Config

            ##
            # NOTE: `> /dev/null 2>&1` is used to hide output.
            # https://unix.stackexchange.com/a/119650/394253
            #
            step Services::RunShellCommand, in: {command: -> { "which node > /dev/null 2>&1" }}
          end
        end
      end
    end
  end
end
