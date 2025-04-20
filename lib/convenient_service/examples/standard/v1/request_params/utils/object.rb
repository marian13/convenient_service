# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "object/blank"
require_relative "object/present"

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module Object
              class << self
                def blank?(object)
                  Blank.call(object)
                end

                def present?(object)
                  Present.call(object)
                end
              end
            end
          end
        end
      end
    end
  end
end
