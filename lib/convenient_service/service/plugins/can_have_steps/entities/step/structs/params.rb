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
          class Step
            module Structs
              Params = ::Struct.new(:action, :inputs, :outputs, :index, :container, :organizer, :extra_kwargs, keyword_init: true)
            end
          end
        end
      end
    end
  end
end
