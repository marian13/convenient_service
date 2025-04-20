# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class MergeSections
            include ConvenientService::Standard::Config

            attr_reader :header, :body

            step :validate_header,
              in: :header

            step :validate_body,
              in: :body

            step :result,
              in: [
                :header,
                :body
              ]

            def initialize(header:, body:)
              @header = header
              @body = body
            end

            def result
              success(merged_sections: "#{header}\n#{body}")
            end

            def validate_header
              return error("Header is `nil`") if header.nil?
              return error("Header is empty") if header.empty?

              success
            end

            def validate_body
              return error("Body is `nil`") if body.nil?
              return error("Body is empty") if body.empty?

              success
            end
          end
        end
      end
    end
  end
end
