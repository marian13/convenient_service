# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ##
  # Intermediate module/namespace to access plugins. See `Constant Summary` for examples.
  #
  # @api public
  # @since 1.0.0
  # @return [Module]
  #
  module Plugins
    ##
    # Intermediate module/namespace to access plugins that can be applied to several types of entities.
    #
    # @api public
    # @since 1.0.0
    # @return [Module]
    #
    # @example Common plugin `CanHaveCallbacks` is used by both services and steps.
    #   ##
    #   # Since the `CanHaveCallbacks` common plugin is included by default by the standard config,
    #   # the example below shows how to remove it instead of adding it.
    #   #
    #   class Service
    #     include ConvenientService::Standard::Config
    #
    #     concerns do
    #       delete ConvenientService::Plugins::Common::CanHaveCallbacks::Concern
    #     end
    #
    #     middlewares :result do
    #       delete ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware
    #     end
    #
    #     entity :Step do
    #       concerns do
    #         delete ConvenientService::Plugins::Common::CanHaveCallbacks::Concern
    #       end
    #
    #       middlewares :result do
    #         delete ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware
    #       end
    #     end
    #
    #     ##
    #     # Raises since `CanHaveCallbacks` is removed.
    #     #
    #     before :result do
    #     end
    #
    #     def result
    #       success
    #     end
    #   end
    #
    # @example Shorter way to remove `CanHaveCallbacks` plugin.
    #   ##
    #   # Some common plugin groups like `:callbacks` can be removed by config option.
    #   #
    #   class Service
    #     include ConvenientService::Standard::Config.without(:callbacks)
    #
    #     ##
    #     # Raises since `CanHaveCallbacks` is removed.
    #     #
    #     before :result do
    #     end
    #
    #     def result
    #       success
    #     end
    #   end
    #
    Common = ::ConvenientService::Plugins::Common
  end
end
