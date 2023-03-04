# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class ExtractParamsFromBody
            include ConvenientService::Standard::Config

            ##
            # IMPORTANT:
            #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
            #   - It will be reenabled after the introduction of thread-safety specs.
            #   - Do not use it in production yet.
            #
            middlewares :step, scope: :class do
              use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
            end

            attr_reader :request

            step :parse_body, in: :request, out: :body
            step :parse_json, in: :body, out: :json
            step :extract_params, in: :json, out: :params
            step :symbolize_keys, in: :params, out: reassign(:params)

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
