# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertValidRubySyntax
            include ConvenientService::Standard::Config

            attr_reader :content

            def initialize(content:)
              @content = content
            end

            def result
              ##
              # NOTE: `> /dev/null 2>&1` is used to hide output.
              # https://unix.stackexchange.com/a/119650/394253
              #
              check_ruby_syntax_result = Services::RunShell.result(command: "ruby -c #{file.path} > /dev/null 2>&1")

              return error("`#{content}` contains invalid Ruby syntax") unless check_ruby_syntax_result.success?

              success
            end

            private

            def file
              @file ||= ::Tempfile.new.tap { |tempfile| tempfile.write(content) }.tap(&:close)
            end
          end
        end
      end
    end
  end
end
