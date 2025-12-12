# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "dependencies/built_in"
require_relative "dependencies/extractions"
require_relative "dependencies/queries"

module ConvenientService
  ##
  # `ConvenientService::Dependencies` can dynamically require plugins/extensions that have external dependencies.
  #
  # @internal
  #   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
  #
  module Dependencies
    extend Queries
  end
end
