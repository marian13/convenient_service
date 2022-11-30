# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module ResponseParams
        module Services
          class LogParams
            include ConvenientService::Standard::Config

            attr_reader :params, :tag

            def initialize(params:, tag: "")
              @params = params
              @tag = tag
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
