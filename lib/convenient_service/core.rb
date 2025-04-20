# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "core/concern"

require_relative "core/constants"
require_relative "core/entities"

require_relative "core/aliases"

module ConvenientService
  module Core
    include Support::Concern

    ##
    # @internal
    #   TODO: Allow to include `Core` only to classes?
    #
    included do
      include Concern

      ##
      # IMPORTANT: Intentionally initializes config (and its mutex) to ensure thread-safety.
      #
      __convenient_service_config__
    end
  end
end
