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
              Params = ::Struct.new(:action, :inputs, :outputs, :strict, :index, :container, :organizer, :extra_kwargs, keyword_init: true) do
                def to_callback_arguments
                  Support::Arguments.new(action, in: inputs, out: outputs, strict: strict, index: index, **extra_kwargs)
                end
              end
            end
          end
        end
      end
    end
  end
end
