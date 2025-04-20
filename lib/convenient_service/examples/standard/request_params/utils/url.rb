# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "url/valid"

module ConvenientService
  module Examples
    module Standard
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
