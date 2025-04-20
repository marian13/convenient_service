# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Array
      module Exceptions
        class NonIntegerIndex < ::ConvenientService::Exception
          def initialize_with_kwargs(index:)
            message = <<~TEXT
              Index `#{index.inspect}` is NOT an integer.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
