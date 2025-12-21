# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "feature/core"
require_relative "feature/plugins"
require_relative "feature/configs"

module ConvenientService
  ##
  # Intermediate module/namespace to access core, plugins and configs that can be applied only to features.
  #
  # @api public
  # @since 1.0.0
  # @return [Module]
  #
  # @note Feature core expected to be used via {ConvenientService::Feature::Core}.
  # @note Feature configs expected to be used via {ConvenientService::Feature::Standard::Config} alias.
  # @note Feature plugins expected to be used via {ConvenientService::Plugins::Feature} alias.
  #
  module Feature
  end
end
