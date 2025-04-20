# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Constants
          SUCCESS_STATUS = :success
          FAILURE_STATUS = :failure
          ERROR_STATUS = :error

          DEFAULT_SUCCESS_DATA = {}
          DEFAULT_FAILURE_DATA = {}
          DEFAULT_ERROR_DATA = {}

          DEFAULT_SUCCESS_MESSAGE = ""
          DEFAULT_FAILURE_MESSAGE = ""
          DEFAULT_ERROR_MESSAGE = ""

          DEFAULT_SUCCESS_CODE = :default_success
          DEFAULT_FAILURE_CODE = :default_failure
          DEFAULT_ERROR_CODE = :default_error
        end
      end
    end
  end
end
