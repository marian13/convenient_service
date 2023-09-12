# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class ExtractParamsFromPath
              include ConvenientService::Standard::V1::Config

              attr_reader :request, :pattern

              step :parse_path, in: :request, out: :path
              step :match_pattern, in: [:path, :pattern], out: :match_data
              step :extract_params, in: :match_data, out: :params

              def initialize(request:, pattern:)
                @request = request
                @pattern = pattern
              end

              private

              def parse_path
                path = Utils::HTTP::Request.parse_path(request.to_s)

                return success(path: path) if path

                error(
                  <<~MESSAGE
                    Failed to resolve path since request is NOT HTTP parsable.

                    Request:
                    ---
                    #{request}
                    ---
                  MESSAGE
                )
              end

              def match_pattern
                match_data = path.match(pattern)

                return success(match_data: match_data) if match_data

                error("Path `#{path}` does NOT match pattern `#{pattern}`.")
              end

              def extract_params
                params = {
                  id: match_data[:id],
                  format: match_data[:format]
                }

                success(params: params)
              end
            end
          end
        end
      end
    end
  end
end
