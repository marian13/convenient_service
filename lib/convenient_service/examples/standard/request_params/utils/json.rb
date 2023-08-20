# frozen_string_literal: true

require_relative "json/safe_parse"

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Utils
          module JSON
            class << self
              def safe_parse(json_string, default_value: nil)
                SafeParse.call(json_string, default_value: default_value)
              end
            end
          end
        end
      end
    end
  end
end
