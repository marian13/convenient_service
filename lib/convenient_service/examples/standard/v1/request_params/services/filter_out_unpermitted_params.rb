# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class FilterOutUnpermittedParams
              include ConvenientService::Standard::V1::Config

              attr_reader :params, :permitted_keys

              def initialize(params:, permitted_keys:)
                @params = params
                @permitted_keys = permitted_keys
              end

              def result
                success(params: params.slice(*permitted_keys))
              end
            end
          end
        end
      end
    end
  end
end
