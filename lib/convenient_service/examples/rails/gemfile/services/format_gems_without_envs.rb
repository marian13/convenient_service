# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::Gemfile::Services::FormatGemsWithoutEnvs.result(
#   parsed_content: {
#     gems: [
#       {
#         envs: [],
#         line: %(gem "bootsnap", ">= 1.4.4", require: false)
#       },
#       {
#         envs: [],
#         line: %(gem "pg")
#       },
#       {
#         envs: [],
#         line: %(gem "rails", "~> 6.1.3", ">= 6.1.3.2")
#       },
#       {
#         envs: [],
#         line: %(gem "webpacker", "~> 5.0")
#       },
#       {
#         envs: [],
#         line: %(gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby])
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
      module Gemfile
        module Services
          class FormatGemsWithoutEnvs
            EMPTY_LINE = ""
            ENTER = "\n"

            include RailsServiceConfig

            attr_accessor :parsed_content

            def result
              success(formatted_content: format_content)
            end

            private

            def format_content
              return "" if gems_without_envs.none?

              gems_without_envs
                .map { |gem| gem[:line] }
                .reduce(EMPTY_LINE.dup) { |content, line| content << line << ENTER }
            end

            def gems_without_envs
              @gems_without_envs ||= parsed_content[:gems].to_a.select { |gem| gem[:envs].none? }
            end
          end
        end
      end
    end
  end
end
