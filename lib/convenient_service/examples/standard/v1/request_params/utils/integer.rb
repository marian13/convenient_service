# frozen_string_literal: true

##
# @internal
#   NOTE: `require_relative "integer/safe_parse"` does NOT work. Why?
#
require_relative "integer/safe_parse"

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module Integer
              class << self
                def safe_parse(string)
                  SafeParse.call(string)
                end
              end
            end
          end
        end
      end
    end
  end
end
