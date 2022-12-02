# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class ExtractParamsFromBody
            include ConvenientService::Standard::Config

            attr_reader :request

            step :parse_body, in: :request, out: :body
            step :parse_json, in: :body, out: :json
            step :extract_params, in: :json, out: :params

            def initialize(request:)
              @request = request
            end

            private

            def parse_body
              body = Utils::HTTP::Request.parse_body(request.to_s)

              return success(body: body) if body

              error(
                <<~MESSAGE
                  Request has invalid body.

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
              success(params: json.transform_keys(&:to_sym))
            end
          end
        end
      end
    end
  end
end
