# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Plugins
    ##
    # Intermediate module/namespace to access plugins that can be applied only to services.
    #
    # @api public
    # @since 1.0.0
    # @return [Module]
    #
    # @example Service plugin `CanHaveRollbacks` can be used only by services.
    #   class Service
    #     include ConvenientService::Standard::Config
    #
    #     middlewares :result do
    #       insert_after \
    #         ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware,
    #         ConvenientService::Plugins::Service::CanHaveRollbacks::Middleware
    #     end
    #
    #     def result
    #       success
    #     end
    #
    #     ##
    #     # Is called in case of `failure` or `error` from `result`, since `CanHaveRollbacks` is now enabled.
    #     #
    #     def rollback_result
    #       puts "from `rollback_result`"
    #     end
    #   end
    #
    # @example Shorter way to add `CanHaveRollbacks` plugin.
    #   ##
    #   # Some service plugin groups like `:rollbacks` can be added by config option.
    #   #
    #   class Service
    #     include ConvenientService::Standard::Config.with(:rollbacks)
    #
    #     def result
    #       success
    #     end
    #
    #     ##
    #     # Is called in case of `failure` or `error` from `result`, since `CanHaveRollbacks` is now enabled.
    #     #
    #     def rollback_result
    #       puts "from `rollback_result`"
    #     end
    #   end
    #
    Service = ::ConvenientService::Service::Plugins
  end
end
