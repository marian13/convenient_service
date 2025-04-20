# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "timeout/with_timeout"

module ConvenientService
  module Examples
    module Standard
      class Factorial
        module Utils
          module Timeout
            class << self
              def with_timeout(...)
                WithTimeout.call(...)
              end
            end
          end
        end
      end
    end
  end
end
