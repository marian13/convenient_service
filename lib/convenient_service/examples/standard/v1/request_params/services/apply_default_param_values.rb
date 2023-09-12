# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class ApplyDefaultParamValues
              include ConvenientService::Standard::V1::Config

              attr_reader :params, :defaults

              def initialize(params:, defaults:)
                @params = params
                @defaults = defaults
              end

              def result
                success(params: defaults.merge(params))
              end
            end
          end
        end
      end
    end
  end
end
