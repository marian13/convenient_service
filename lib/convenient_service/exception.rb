# frozen_string_literal: true

##
# Base class for all `ConvenientService` exceptions.
# Can be used as a catch-all solution, for example:
#
#   begin
#     any_service.result
#   rescue ConvenientService::Exception => exception
#     puts exception.message
#   end
#
module ConvenientService
  class Exception < ::StandardError
  end
end
