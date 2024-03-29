# frozen_string_literal: true

require_relative "url/valid"

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module URL
              class << self
                def valid?(url)
                  Valid.call(url)
                end
              end
            end
          end
        end
      end
    end
  end
end
