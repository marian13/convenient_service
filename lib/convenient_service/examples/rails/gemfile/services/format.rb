# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::Gemfile::Services::Format.result(path: "Gemfile")
# result = ConvenientService::Examples::Rails::Gemfile::Services::Format.result(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class Format
            include RailsService::Config

            attribute :path, :string

            step Services::ReadFileContent, in: :path, out: :content
            step Services::StripComments, in: :content, out: :content_without_comments
            step Services::ParseContent, in: {content: :content_without_comments}, out: :parsed_content
            step Services::FormatHeader, in: :parsed_content, out: {formatted_content: :formatted_header_content}
            step Services::FormatBody, in: :parsed_content, out: {formatted_content: :formatted_body_content}

            before :result do
              @progressbar = ::ProgressBar.create(title: "Formatting", total: steps.count)
            end

            after :step do |step_result|
              @progressbar.increment
            end
          end
        end
      end
    end
  end
end
