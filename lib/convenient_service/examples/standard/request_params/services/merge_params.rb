# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class MergeParams
            include ConvenientService::Standard::Config

            attr_reader :params_from_path, :params_from_body

            def initialize(params_from_path:, params_from_body:)
              @params_from_path = params_from_path
              @params_from_body = params_from_body
            end

            def result
              success(params: params_from_path.merge(params_from_body))
            end
          end
        end
      end
    end
  end
end
