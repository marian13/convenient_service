# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::V1::Gemfile::Services::PrintShellCommand.result(command: "ls -a")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class PrintShellCommand
              include ConvenientService::Standard::V1::Config

              attr_reader :command, :skip, :out

              def initialize(command:, skip: false, out: $stdout)
                @command = command
                @skip = skip
                @out = out
              end

              def result
                return failure(command: "Command is `nil`") if command.nil?
                return failure(command: "Command is empty?") if command.empty?

                return error("Printing of shell command `#{command}` is skipped") if skip

                out.puts

                out.puts ::Paint["$ #{command}", :blue, :bold]

                success
              end

              def fallback_error_result
                success
              end
            end
          end
        end
      end
    end
  end
end
