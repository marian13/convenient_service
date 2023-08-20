# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable.result
#
module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class AssertNodeAvailable
            include ConvenientService::Standard::Config

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
