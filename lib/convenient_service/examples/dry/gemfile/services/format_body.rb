# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Dry::Gemfile::Services::FormatBody.result(
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
    module Dry
      class Gemfile
        module Services
          class FormatBody
            include DryService::Config

            option :parsed_content

            contract do
              schema do
                required(:parsed_content).hash do
                  optional(:gems).array(:hash) do
                    ##
                    # NOTE: required(:envs).array(:symbol) raises `Dry::Container::KeyError: key not found: "{:type?=>Symbol}"`.
                    #
                    required(:envs).array(type?: ::Symbol)
                    required(:line).value(:string)
                  end
                end
              end
            end

            step Services::FormatGemsWithoutEnvs,
              in: :parsed_content,
              out: [{formatted_content: :formatted_gems_without_envs_content}]

            step Services::FormatGemsWithEnvs,
              in: :parsed_content,
              out: [{formatted_content: :formatted_gems_with_envs_content}]

            step :result,
              in: [:formatted_gems_without_envs_content, :formatted_gems_with_envs_content],
              out: :formatted_content

            def result
              success(formatted_content: format_content)
            end

            private

            def format_content
              [formatted_gems_without_envs_content, formatted_gems_with_envs_content].reject(&:empty?).join("\n")
            end
          end
        end
      end
    end
  end
end
