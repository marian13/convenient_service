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
            option :out, default: -> { $stdout }

            contract do
              schema do
                required(:text).value(:string)
              end
            end

            def result
              out.puts

              out.puts ::Paint["$ #{text}", :blue, :bold]

              success
            end
          end
        end
      end
    end
  end
end
