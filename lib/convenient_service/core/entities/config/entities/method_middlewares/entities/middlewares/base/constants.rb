# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Base
                  module Constants
                    ##
                    # @return [ConvenientService::Support::UniqueValue]
                    #
                    ANY_METHOD = Support::UniqueValue.new("any_method")

                    ##
                    # @return [ConvenientService::Support::UniqueValue]
                    #
                    ANY_SCOPE = Support::UniqueValue.new("any_scope")

                    ##
                    # @return [ConvenientService::Support::UniqueValue]
                    #
                    ANY_ENTITY = Support::UniqueValue.new("any_entity")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
