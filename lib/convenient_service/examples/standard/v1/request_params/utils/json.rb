# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "json/safe_parse"

module ConvenientService
  module Examples
    module Standard
      module V1
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
end
