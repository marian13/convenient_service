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
            module Concern
              module ClassMethods
                def cast(other, **options)
                  Commands::CastMethod.call(other: other, options: options)
                end
              end
            end
          end
        end
      end
    end
  end
end
