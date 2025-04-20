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
            class Blank < ConvenientService::Command
              attr_reader :object

              def initialize(object)
                @object = object
              end

              ##
              # https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F
              #
              def call
                object.respond_to?(:empty?) ? !!object.empty? : !object
              end
            end
          end
        end
      end
    end
  end
end
