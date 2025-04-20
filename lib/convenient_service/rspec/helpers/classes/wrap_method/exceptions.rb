# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class WrapMethod < Support::Command
          module Exceptions
            class ChainAttributePreliminaryAccess < ::ConvenientService::Exception
              ##
              # @param attribute [Symbol]
              # @return [void]
              #
              def initialize_with_kwargs(attribute:)
                message = <<~TEXT
                  Chain attribute `#{attribute}` is accessed before the chain is called.
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
