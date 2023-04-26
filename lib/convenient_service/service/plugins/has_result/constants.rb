# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Constants
          SUCCESS_STATUS = :success
          FAILURE_STATUS = :failure
          ERROR_STATUS = :error

          DEFAULT_SUCCESS_DATA = {}
          DEFAULT_FAILURE_DATA = {}
          ERROR_DATA = {}

          SUCCESS_MESSAGE = ""
          DEFAULT_FAILURE_MESSAGE = ""
          DEFAULT_ERROR_MESSAGE = ""

          SUCCESS_CODE = :success
          FAILURE_CODE = :failure
          DEFAULT_ERROR_CODE = :default_error
        end
      end
    end
  end
end
