# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::V1::Gemfile::Services::ParseContent.result(
#   content:     <<~'RUBY'
#     ruby "3.0.1"
#     source "https://rubygems.org"

#     git_source(:github) { |repo| "https://github.com/#{repo}.git" }

#     gem "bootsnap", ">= 1.4.4", require: false

#     group :development do
#       gem "listen", "~> 3.3"
#     end

#     group :development, :test do
#       gem "rspec-rails"
#     end
#   RUBY
# )
#
# NOTE: Check the corresponding spec file to see more examples.
#
module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          module Services
            class ParseContent
              RUBY_REGEX = /\A\s*ruby/
              SOURCE_REGEX = /\A\s*source/
              GIT_SOURCE_REGEX = /\A\s*git_source/
              GROUP_REGEX = /\A\s*group/
              GEM_REGEX = /\A\s*gem/
              BLOCK_END_REGEX = /\A\s*end/
              ENV_SCAN_REGEX = /:(\w+)/

              include RailsService::Config

              attribute :content, :string

              validates :content, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

              step Services::AssertValidRubySyntax, in: :content
              step :result, in: :content, out: :parsed_content

              def result
                success(data: {parsed_content: parse_content})
              end

              def parse_content
                hash = ::Hash.new { |h, k| h[k] = [] }

                ::StringIO.open(content) do |io|
                  envs = []

                  until io.eof?
                    line = io.readline.rstrip

                    case line
                    when RUBY_REGEX
                      hash[:ruby] << line
                    when SOURCE_REGEX
                      hash[:source] << line
                    when GIT_SOURCE_REGEX
                      hash[:git_source] << line
                    when GROUP_REGEX
                      envs = line.scan(ENV_SCAN_REGEX).map(&:first).map(&:to_sym)
                    when GEM_REGEX
                      hash[:gems] << {envs: envs, line: line.lstrip}
                    when BLOCK_END_REGEX
                      envs = []
                    else
                      hash[:rest] << line
                    end
                  end
                end

                hash
              end
            end
          end
        end
      end
    end
  end
end
