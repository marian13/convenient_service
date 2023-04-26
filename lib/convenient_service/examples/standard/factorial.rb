# frozen_string_literal: true

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
      module Factorial
        include ConvenientService::Feature

        entry :calculate do |number|
          Services::Calculate[number: number]
        end
      end
    end
  end
end
