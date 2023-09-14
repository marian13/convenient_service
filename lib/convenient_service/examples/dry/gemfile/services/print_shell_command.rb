# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Dry::Gemfile::Services::PrintShellCommand.result(command: "ls -a")
#
module ConvenientService
  module Examples
    module Dry
      class Gemfile
        module Services
          class PrintShellCommand
            include DryService::Config

            option :command
            option :skip, default: -> { false }
            option :out, default: -> { $stdout }

            contract do
              schema do
                required(:command).filled(:string)
              end
            end

            def result
              return failure("Printing of shell command `#{command}` is skipped") if skip

              out.puts

              out.puts ::Paint["$ #{command}", :blue, :bold]

              success
            end

            def fallback_failure_result
              success
            end
          end
        end
      end
    end
  end
end
