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
#   result = ConvenientService::Examples::Standard::V1::Factorial.calculate(10)
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Factorial
          include ConvenientService::Feature::Standard::Config

          entry :calculate do |number|
            Services::Calculate[number: number]
          end
        end
      end
    end
  end
end
