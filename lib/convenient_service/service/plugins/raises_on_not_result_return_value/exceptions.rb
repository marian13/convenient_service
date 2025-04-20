# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module RaisesOnNotResultReturnValue
        module Exceptions
          class ReturnValueNotKindOfResult < ::ConvenientService::Exception
            def initialize_with_kwargs(service:, result:, method:)
              message = <<~TEXT
                Return value of service `#{service.class}` is NOT a `Result`.
                It is `#{result.class}`.

                Did you forget to call `success`, `failure`, or `error` from the `:#{method}` method?
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
