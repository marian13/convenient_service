# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          module Services
            class AssertValidRubySyntax
              include RailsService::Config

              attribute :content, :string

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
end
