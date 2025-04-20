# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "factorial/services"
require_relative "factorial/utils"

##
# @internal
#   Usage examples:
#
#   result = ConvenientService::Examples::Standard::Factorial.calculate(10)
#
module ConvenientService
  module Examples
    module Standard
      class Factorial
        include ConvenientService::Feature::Standard::Config

        entry :calculate

        def calculate(number)
          Services::Calculate[number: number]
        end
      end
    end
  end
end
