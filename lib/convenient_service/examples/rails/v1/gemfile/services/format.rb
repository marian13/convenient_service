# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::V1::Gemfile::Services::Format.result(path: "Gemfile")
# result = ConvenientService::Examples::Rails::V1::Gemfile::Services::Format.result(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          module Services
            class Format
              include RailsService::Config

              attribute :path, :string

              validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

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
            end
          end
        end
      end
    end
  end
end
