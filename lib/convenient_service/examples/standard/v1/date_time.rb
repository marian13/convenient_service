# frozen_string_literal: true

require_relative "date_time/services"

##
# @internal
#   Usage examples:
#
#   result = ConvenientService::Examples::Standard::V1::DateTime.safe_parse("24-02-2024", "%d-%m-%Y")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class DateTime
          include ConvenientService::Feature

          entry :safe_parse do |string, format|
            Services::SafeParse[string: string, format: format]
          end
        end
      end
    end
  end
end
