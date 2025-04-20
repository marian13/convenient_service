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
              class Caller
                module Concern
                  module ClassMethods
                    ##
                    # @param other [Hash, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller, nil]
                    #
                    def cast(other)
                      Commands::CastCaller.call(other: other)
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
