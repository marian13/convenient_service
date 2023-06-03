# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::PrintShellCommand.result(text: "ls -a")
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class PrintShellCommand
            include ConvenientService::Standard::Config

            attr_reader :text, :skip, :out

            def initialize(text:, skip: false, out: $stdout)
              @text = text
              @skip = skip
              @out = out
            end

            def result
              return failure(text: "Text is `nil`") if text.nil?
              return failure(text: "Text is empty?") if text.empty?

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
