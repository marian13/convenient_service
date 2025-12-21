# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Plugins
    ##
    # Intermediate module/namespace to access plugins that can be applied only to features.
    #
    # @api public
    # @since 1.0.0
    # @return [Module]
    #
    # @example Feature plugin `CanHaveEntries` is used for features.
    #   ##
    #   # Since the `CanHaveEntries` feature plugin is included by default by the feature standard config,
    #   # the example below shows how to remove it instead of adding it.
    #   #
    #   class Feature
    #     include ConvenientService::Feature::Standard::Config
    #
    #     concerns do
    #       delete ConvenientService::Plugins::Feature::CanHaveEntries::Concern
    #     end
    #
    #     ##
    #     # Raises since `CanHaveEntries` is removed.
    #     #
    #     entry :main
    #
    #     def main
    #       :main_entry_value
    #     end
    #   end
    #
    Feature = ::ConvenientService::Feature::Plugins
  end
end
