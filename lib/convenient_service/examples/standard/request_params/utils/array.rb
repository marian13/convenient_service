# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "array/wrap"

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Utils
          module Array
            class << self
              def wrap(object)
                Wrap.call(object)
              end
            end
          end
        end
      end
    end
  end
end
