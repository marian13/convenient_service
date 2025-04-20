# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "date_time/services"

##
# @internal
#   Usage examples:
#
#   result = ConvenientService::Examples::Standard::DateTime.safe_parse("24-02-2024", "%d-%m-%Y")
#
module ConvenientService
  module Examples
    module Standard
      class DateTime
        include ConvenientService::Feature::Standard::Config

        entry :safe_parse

        def safe_parse(string, format)
          Services::SafeParse[string: string, format: format]
        end
      end
    end
  end
end
