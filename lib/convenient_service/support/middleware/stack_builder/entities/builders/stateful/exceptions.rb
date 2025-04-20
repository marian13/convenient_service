# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Stateful
              module Exceptions
                class MissingMiddleware < ::ConvenientService::Exception
                  ##
                  # @param middleware [#call<Hash>]
                  # @return [void]
                  #
                  def initialize_with_kwargs(middleware:)
                    message = <<~TEXT
                      Middleware `#{middleware.inspect}` is NOT found in the stack.
                    TEXT

                    initialize(message)
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
