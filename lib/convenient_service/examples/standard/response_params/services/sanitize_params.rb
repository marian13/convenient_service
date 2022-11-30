# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module ResponseParams
        module Services
          class SanitizeParams
            include ConvenientService::Standard::Config

            attr_reader :params

            def initialize(params:)
              @params = params
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
