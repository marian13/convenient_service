# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class ReplaceFileContent
              include ConvenientService::Standard::V1::Config

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
                return failure(path: "Path is `nil`") if path.nil?
                return failure(path: "Path is empty") if path.empty?

                success
              end

              def validate_content
                return failure(content: "Content is `nil`") if content.nil?

                success
              end
            end
          end
        end
      end
    end
  end
end
