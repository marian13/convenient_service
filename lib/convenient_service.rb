# frozen_string_literal: true

##
# @internal
#   Convenient Service Dependencies.
#
require_relative "convenient_service/dependencies"

##
# @internal
#   Convenient Service Inner Tools and Utilities.
#
require_relative "convenient_service/logger"
require_relative "convenient_service/exception"
require_relative "convenient_service/support"
require_relative "convenient_service/utils"
require_relative "convenient_service/version"

##
# @internal
#   Convenient Service Core.
#
require_relative "convenient_service/core"

##
# @internal
#   Convenient Service Default Plugins/Extensions.
#
require_relative "convenient_service/common"
require_relative "convenient_service/service"

##
# @internal
#   Convenient Service Feature.
#
require_relative "convenient_service/feature"

##
# @internal
#   Convenient Service Aliases.
#
require_relative "convenient_service/aliases"

module ConvenientService
  class << self
    ##
    # @api public
    #
    # @return [ConvenientService::Logger]
    #
    def logger
      Logger.instance
    end
  end
end
