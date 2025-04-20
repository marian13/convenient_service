# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "cowsay/services"

##
# @internal
#   Usage examples:
#
#   result = ConvenientService::Examples::Standard::V1::Cowsay.print("Hello")
#   result = ConvenientService::Examples::Standard::V1::Cowsay.print("Hi")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Cowsay
          include ConvenientService::Feature::Standard::Config

          entry :print do |text = "Hello World!", out: $stdout|
            Services::Print[text: text, out: out]
          end
        end
      end
    end
  end
end
