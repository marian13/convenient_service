# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Standard::Gemfile::Services::ParseContent.result(
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
    module Standard
      module Gemfile
        module Services
          class ParseContent
            RUBY_REGEX = /\A\s*ruby/
            SOURCE_REGEX = /\A\s*source/
            GIT_SOURCE_REGEX = /\A\s*git_source/
            GROUP_REGEX = /\A\s*group/
            GEM_REGEX = /\A\s*gem/
            BLOCK_END_REGEX = /\A\s*end/
            ENV_SCAN_REGEX = /:(\w+)/

            include ConvenientService::Configs::Standard

            include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
            include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
            include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

            attribute :content, :string

            validates :content, presence: true

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
