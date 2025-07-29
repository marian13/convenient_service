# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Service
            module Concern
              module ClassMethods
                ##
                # @param other [Object] Can be any type.
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service, nil]
                #
                def cast(other)
                  case other
                  when ::Class then new(other)
                  when Service then new(other.klass)
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
