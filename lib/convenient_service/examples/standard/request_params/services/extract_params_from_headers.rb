# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class ExtractParamsFromHeaders
            include ConvenientService::Standard::Config

            attr_reader :request

            def initialize(request:)
              @request = request
            end

            def result
              success(params: {})
            end
          end
        end
      end
    end
  end
end
