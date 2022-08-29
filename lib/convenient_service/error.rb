# frozen_string_literal: true

##
# Base class for all `ConvenientService' errors.
# Can be used as a catch-all solution, for example:
#
#   begin
#     any_service.result
#   rescue ConvenientService::Error => error
#     puts error.message
#   end
#
module ConvenientService
  class Error < ::StandardError
  end
end
