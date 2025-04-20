# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE: `require_relative "integer/safe_parse"` does NOT work. Why?
#
require_relative "integer/safe_parse"

module ConvenientService
  module Examples
    module Standard
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
