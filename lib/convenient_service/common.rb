# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "common/plugins"

module ConvenientService
  ##
  # Intermediate module/namespace to access plugins that can be applied to several types of entities.
  #
  # @api private
  # @since 1.0.0
  # @return [Module]
  #
  # @note Common plugins expected to be used via {ConvenientService::Plugins::Common} alias.
  #
  module Common
  end
end
