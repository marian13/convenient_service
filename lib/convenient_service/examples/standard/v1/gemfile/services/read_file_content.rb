# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class ReadFileContent
              include ConvenientService::Standard::V1::Config

              attr_reader :path

              step :validate_path, in: :path
              step Services::AssertFileExists, in: :path
              step Services::AssertFileNotEmpty, in: :path
              step :result, in: :path, out: :content

              def initialize(path:)
                @path = path
              end

              def result
                success(data: {content: ::File.read(path)})
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
