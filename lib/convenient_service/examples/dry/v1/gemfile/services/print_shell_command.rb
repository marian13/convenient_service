# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Dry::V1::Gemfile::Services::PrintShellCommand.result(text: "ls -a")
#
module ConvenientService
  module Examples
    module Dry
      module V1
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
