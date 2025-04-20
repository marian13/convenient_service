# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Standard::V1::Gemfile::Services::Format.result(path: "Gemfile")
# result = ConvenientService::Examples::Standard::V1::Gemfile::Services::Format.result(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class Format
              include ConvenientService::Standard::V1::Config

              attr_reader :path

              step :validate_path,
                in: :path

              step Services::ReadFileContent,
                in: :path,
                out: :content

              step Services::StripComments,
                in: :content,
                out: :content_without_comments

              step Services::ParseContent,
                in: {content: :content_without_comments},
                out: :parsed_content

              step Services::FormatHeader,
                in: :parsed_content,
                out: {formatted_content: :formatted_header_content}

              step Services::FormatBody,
                in: :parsed_content,
                out: {formatted_content: :formatted_body_content}

              step Services::MergeSections,
                in: [
                  {header: :formatted_header_content},
                  {body: :formatted_body_content}
                ],
                out: :merged_sections

              step Services::ReplaceFileContent,
                in: [
                  :path,
                  {content: :merged_sections}
                ]

              before :result do
                @progressbar = ::ProgressBar.create(title: "Formatting", total: steps.count)
              end

              after :step do |step|
                @progressbar.increment
              end

              def initialize(path:)
                @path = path
              end

              private

              def validate_path
                return failure(path: "Path is `nil`") if path.nil?
                return failure(path: "Path is empty") if path.empty?

                success
              end
            end
          end
        end
      end
    end
  end
end
