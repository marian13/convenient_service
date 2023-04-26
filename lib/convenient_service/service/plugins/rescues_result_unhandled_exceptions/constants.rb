# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Constants
          ##
          # @return [Integer]
          #
          DEFAULT_MAX_BACKTRACE_SIZE = 10

          ##
          # @return [String]
          #
          MESSAGE_LINE_PREFIX = " " * 2
        end
      end
    end
  end
end
