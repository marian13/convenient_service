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
            include ConvenientService::Configs::Standard

            attr_reader :text, :out

            def initialize(text:, out: $stdout)
              @text = text
              @out = out
            end

            def result
              return failure(text: "Text is `nil'") if text.nil?
              return failure(text: "Text is empty?") if text.empty?

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
