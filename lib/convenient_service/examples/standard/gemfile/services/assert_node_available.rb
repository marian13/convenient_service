# frozen_string_literal: true
require 'byebug'
##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable.result
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertNodeAvailable
            include ConvenientService::Standard::Config

            ##
            # NOTE: `commit_config!` is used explicitly, since `step` method is NOT missed. It will be taken from `Turnip`.
            # - https://github.com/jnicklas/turnip/blob/master/lib/turnip.rb#L29
            # - https://github.com/jnicklas/turnip/blob/8272ef92902329d2d29bb5ba2b29cd431523478f/lib/turnip/define.rb#L3
            #
            # TODO: Troubleshooting guide.
            #
            # byebug
            commit_config!

            ##
            # NOTE: `> /dev/null 2>&1` is used to hide output.
            # https://unix.stackexchange.com/a/119650/394253
            #
            step Services::RunShell, in: {command: -> { "which node > /dev/null 2>&1" }}
          end
        end
      end
    end
  end
end
