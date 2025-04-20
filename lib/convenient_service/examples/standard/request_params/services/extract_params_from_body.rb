# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Services
          class ExtractParamsFromBody
            include ConvenientService::Standard::Config

            attr_reader :request

            step :parse_body, in: :request, out: :body
            step :parse_json, in: :body, out: :json
            step :extract_params, in: :json, out: :params
            step :symbolize_keys, in: :params, out: :params

            def initialize(request:)
              @request = request
            end

            private

            def parse_body
              body = Utils::HTTP::Request.parse_body(request.to_s)

              return success(body: body) if body

              error(
                <<~MESSAGE
                  Failed to resolve body since request is NOT HTTP parsable.

                  Request:
                  ---
                  #{request}
                  ---
                MESSAGE
              )
            end

            def parse_json
              json = Utils::JSON.safe_parse(body)

              return success(json: json) if json

              error(
                <<~MESSAGE
                  Request body contains invalid json.

                  Request:
                  ---
                  #{request}
                  ---
                MESSAGE
              )
            end

            def extract_params
              success(params: json)
            end

            def symbolize_keys
              success(params: params.transform_keys(&:to_sym))
            end
          end
        end
      end
    end
  end
end
