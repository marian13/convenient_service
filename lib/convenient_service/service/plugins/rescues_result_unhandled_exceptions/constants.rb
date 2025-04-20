# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
