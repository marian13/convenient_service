# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class ReplaceFileContent
            include ConvenientService::Standard::Config

            attr_reader :path, :content

            step :validate_path, in: :path
            step :validate_content, in: :content
            step Services::AssertFileExists, in: :path
            step :result, in: :path

            def initialize(path:, content:)
              @path = path
              @content = content
            end

            def result
              ::File.write(path, content)

              success
            end

            private

            def validate_path
              return error("Path is `nil`") if path.nil?
              return error("Path is empty") if path.empty?

              success
            end

            def validate_content
              return error("Content is `nil`") if content.nil?

              success
            end
          end
        end
      end
    end
  end
end
