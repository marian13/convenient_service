# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class RemoveUnauthorizedParams
            include ConvenientService::Standard::Config

            attr_reader :params, :role

            def initialize(params:, role:)
              @params = params
              @role = role
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
