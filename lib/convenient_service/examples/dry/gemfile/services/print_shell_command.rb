# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Dry::Gemfile::Services::PrintShellCommand.result(text: "ls -a")
#
module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class PrintShellCommand
            include DryService::Config

            option :text
            option :skip, default: -> { false }
            option :out, default: -> { $stdout }

            contract do
              schema do
                required(:text).filled(:string)
              end
            end

            def result
              return error("Printing of shell command `#{text}` is skipped") if skip

              out.puts

              out.puts ::Paint["$ #{text}", :blue, :bold]

              success
            end

            def try_result
              success
            end
          end
        end
      end
    end
  end
end
