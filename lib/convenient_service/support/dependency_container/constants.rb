# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module DependencyContainer
      module Constants
        SCOPES = [
          INSTANCE_SCOPE = :instance,
          CLASS_SCOPE = :class
        ]

        DEFAULT_SCOPE = Constants::INSTANCE_SCOPE
        DEFAULT_PREPEND = false
      end
    end
  end
end
