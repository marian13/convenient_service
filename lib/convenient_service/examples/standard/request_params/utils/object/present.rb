# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
#
#
module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Utils
          module Object
            ##
            # TODO: Specs.
            #
            class Present < ConvenientService::Command
              attr_reader :object

              def initialize(object)
                @object = object
              end

              def call
                Utils::Object.blank?(object)
              end
            end
          end
        end
      end
    end
  end
end
