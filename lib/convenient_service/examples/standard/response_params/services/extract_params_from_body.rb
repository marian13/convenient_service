# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module ResponseParams
        module Services
          class ExtractParamsFromBody
            include ConvenientService::Standard::Config

            attr_reader :response

            def initialize(response:)
              @response = response
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
