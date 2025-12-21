# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "service/core"
require_relative "service/plugins"
require_relative "service/configs"

module ConvenientService
  ##
  # Intermediate module/namespace to access core, plugins and configs that can be applied only to services.
  #
  # @api private
  # @since 1.0.0
  # @return [Module]
  #
  # @note Service core expected to be used via {ConvenientService::Service::Core}.
  # @note Service configs expected to be used via {ConvenientService::Standard::Config} alias.
  # @note Service plugins expected to be used via {ConvenientService::Plugins::Service} alias.
  #
  module Service
  end
end
