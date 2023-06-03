# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class AssertValidRubySyntax
            include DryService::Config

            option :content

            contract do
              schema do
                required(:content).value(:string)
              end
            end

            def result
              ##
              # NOTE: `> /dev/null 2>&1` is used to hide output.
              # https://unix.stackexchange.com/a/119650/394253
              #
              check_ruby_syntax_result = Services::RunShellCommand.result(command: "ruby -c #{file.path} > /dev/null 2>&1")

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
