# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Standard::V1::Gemfile::Services::FormatHeader.result(
#   parsed_content: {
#     ruby: [
#       %(ruby "3.0.1")
#     ],
#     source: [
#       %(source "https://rubygems.org")
#     ],
#     git_source: [
#       %(git_source(:github) { |repo| "https://github.com/\#{repo}.git" })
#     ]
#   },
#   skip_frozen_string_literal: true
# )
#
# NOTE: Check the corresponding spec file to see more examples.
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class FormatHeader
              FROZEN_STRING_LITERAL = "# frozen_string_literal: true"
              EMPTY_LINE = ""
              ENTER = "\n"

              include ConvenientService::Standard::V1::Config

              attr_reader :parsed_content, :skip_frozen_string_literal

              def initialize(parsed_content:, skip_frozen_string_literal: false)
                @parsed_content = parsed_content
                @skip_frozen_string_literal = skip_frozen_string_literal
              end

              def result
                success(formatted_content: format_content)
              end

              private

              def format_content
                content = EMPTY_LINE.dup

                content << FROZEN_STRING_LITERAL << ENTER << ENTER unless skip_frozen_string_literal

                parsed_content.slice(:source, :git_source, :ruby).each do |_group, lines|
                  content << lines.join(ENTER) << ENTER << ENTER
                end

                content.chomp!

                content
              end
            end
          end
        end
      end
    end
  end
end
