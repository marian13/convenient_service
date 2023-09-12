# frozen_string_literal: true

require_relative "request/parse_body"
require_relative "request/parse_path"

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module HTTP
              module Request
                class << self
                  def parse_body(http_string)
                    ParseBody.call(http_string: http_string)
                  end

                  def parse_path(http_string)
                    ParsePath.call(http_string: http_string)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
