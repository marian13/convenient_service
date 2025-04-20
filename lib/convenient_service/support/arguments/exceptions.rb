# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Arguments
      module Exceptions
        class InvalidKeyType < ::ConvenientService::Exception
          ##
          # @param key [Object] Can be any type.
          # @return [void]
          #
          def initialize_with_kwargs(key:)
            message = <<~TEXT
              `#[]` accepts only `Integer` and `String` keys.

              Key `#{key.inspect}` has `#{key.class}` class.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
