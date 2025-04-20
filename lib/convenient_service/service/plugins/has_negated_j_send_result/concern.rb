# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasNegatedJSendResult
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @note Users may override this method to provide custom `negataed_result` behavior.
            #
            def negated_result
              result.negated_result
            end
          end
        end
      end
    end
  end
end
