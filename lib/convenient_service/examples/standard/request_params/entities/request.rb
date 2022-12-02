# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Entities
          class Request
            attr_reader :http_string

            def initialize(http_string)
              @http_string = http_string
            end
          end
        end
      end
    end
  end
end
