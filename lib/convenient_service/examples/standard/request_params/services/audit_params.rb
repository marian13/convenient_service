# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class AuditParams
            include ConvenientService::Standard::Config

            attr_reader :params

            def initialize(params:)
              @params = params
            end

            def result
              success
            end
          end
        end
      end
    end
  end
end
