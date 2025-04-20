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
              class Container
                module Concern
                  module ClassMethods
                    ##
                    # @param other [Hash, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container, nil]
                    #
                    def cast(other)
                      Commands::CastContainer.call(other: other)
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
end
