# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::PrintShellCommand.result(command: "ls -a")
#
module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class PrintShellCommand
            include ConvenientService::Standard::Config

            attr_reader :command, :skip, :out

            def initialize(command:, skip: false, out: $stdout)
              @command = command
              @skip = skip
              @out = out
            end

            def result
              return error("Command is `nil`") if command.nil?
              return error("Command is empty") if command.empty?

              return failure("Printing of shell command `#{command}` is skipped") if skip

              out.puts

              out.puts ::Paint["$ #{command}", :blue, :bold]

              success
            end

            def fallback_result
              success
            end
          end
        end
      end
    end
  end
end
