# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Dry::Gemfile::Services::FormatHeader.result(
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
    module Dry
      module Gemfile
        module Services
          class FormatHeader
            FROZEN_STRING_LITERAL = "# frozen_string_literal: true"
            EMPTY_LINE = ""
            ENTER = "\n"

            include DryServiceConfig

            option :parsed_content
            option :skip_frozen_string_literal, default: -> { false }

            contract do
              schema do
                required(:parsed_content).hash do
                  optional(:ruby).array(:string)
                  optional(:source).array(:string)
                  optional(:git_source).array(:string)
                end

                optional(:skip_frozen_string_literal).value(:bool?)
              end
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
