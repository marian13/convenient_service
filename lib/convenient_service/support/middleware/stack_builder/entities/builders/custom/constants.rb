# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Custom
              module Constants
                ##
                # @return [Proc]
                #
                INITIAL_MIDDLEWARE = ->(env) { env }
              end
            end
          end
        end
      end
    end
  end
end
