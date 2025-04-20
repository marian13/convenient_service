# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveHelpers
      module Classes
        class IgnoringException < Support::Command
          module Exceptions
            class IgnoredExceptionIsNotRaised < ::ConvenientService::Exception
              ##
              # @param exception [StandardError]
              # @return [void]
              #
              def initialize_with_kwargs(exception:)
                message = <<~TEXT
                  Exception `#{exception}` is NOT raised. That is why it is NOT ignored.
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
