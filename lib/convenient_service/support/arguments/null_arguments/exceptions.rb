# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Arguments
      class NullArguments < Support::Arguments
        module Exceptions
          class BlockSetIsNotAllowed < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_without_arguments
              message = <<~TEXT
                Setting a block to null arguments is NOT allowed.

                Consider to create a new arguments object and set block to it instead.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
