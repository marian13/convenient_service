# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::Gemfile::Services::FormatGemsWithEnvs.result(
#   parsed_content: {
#     gems: [
#       {
#         envs: [:development],
#         line: %(gem "listen", "~> 3.3")
#       },
#       {
#         envs: [:development],
#         line: %(gem "web-console", ">= 4.1.0")
#       },
#       {
#         envs: [:development, :test],
#         line: %(gem "rspec-rails")
#       },
#       {
#         envs: [:test],
#         line: %(gem "simplecov", require: false)
#       }
#     ]
#   }
# )
#
# NOTE: Check the corresponding spec file to see more examples.
#
module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class FormatGemsWithEnvs
            BLOCK_END = "end"
            BLOCK_DO = "do"
            COMMA_WITH_SPACE = ", "
            EMPTY_LINE = ""
            ENTER = "\n"
            GROUP = "group"
            SPACE = " "
            TAB = "  "

            include RailsService::Config

            attr_accessor :parsed_content

            def result
              success(formatted_content: format_content)
            end

            private

            def format_content
              return "" if gems_with_envs.none?

              gems_with_envs
                .group_by { |gem| gem[:envs] }
                .sort
                .map { |envs, gems|
                  content = EMPTY_LINE.dup

                  content << GROUP << SPACE << envs.map { |env| ":#{env}" }.join(COMMA_WITH_SPACE) << SPACE << BLOCK_DO << ENTER

                  content << gems.map { |gem| "#{TAB}#{gem[:line]}#{ENTER}" }.join

                  content << BLOCK_END << ENTER
                }
                .join(ENTER)
            end

            def gems_with_envs
              @gems_with_envs ||= parsed_content[:gems].to_a.select { |gem| gem[:envs].any? }
            end
          end
        end
      end
    end
  end
end
