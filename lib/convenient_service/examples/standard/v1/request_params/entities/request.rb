# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Entities
            class Request
              attr_reader :http_string

              def initialize(http_string:)
                @http_string = http_string
              end

              def to_s
                http_string
              end
            end
          end
        end
      end
    end
  end
end
