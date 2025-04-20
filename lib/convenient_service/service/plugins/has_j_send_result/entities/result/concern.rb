# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            ##
            # @internal
            #   This concern is needed for `CastResultClass` and `be_success`, `be_error`, `be_failure` matchers.
            #
            module Concern
            end
          end
        end
      end
    end
  end
end
