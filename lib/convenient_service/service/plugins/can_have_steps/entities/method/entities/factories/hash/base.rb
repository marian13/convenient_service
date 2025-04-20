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
          class Method
            module Entities
              module Factories
                module Hash
                  class Base < Factories::Base
                    ##
                    # @return [Symbol]
                    #
                    def key
                      @key ||= other.keys.first
                    end

                    ##
                    # @return [Object] Can be any object.
                    #
                    def value
                      Utils.memoize_including_falsy_values(self, :@value) { other.values.first }
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
