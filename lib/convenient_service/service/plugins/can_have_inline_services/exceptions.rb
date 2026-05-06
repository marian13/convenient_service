# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveInlineServices
        module Exceptions
          class InlineServiceIsAlreadyDefined < ::ConvenientService::Exception
            ##
            # @param object [Object] Can be any type.
            # @return [void]
            #
            def initialize_with_kwargs(object:)
              message = <<~TEXT
                Definition of already defined inline service can NOT be modified.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
