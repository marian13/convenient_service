# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Services
          class ApplyDefaultParamValues
            include ConvenientService::Standard::Config

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
