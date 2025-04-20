# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        module Exceptions
          class DoubleResult < ::ConvenientService::Exception
            def initialize_with_kwargs(service:)
              message = <<~TEXT
                `#{service.class}` service has a double result.

                Make sure its #result calls only one from the following methods `success`, `failure`, or `error` and only once.

                Maybe you missed `return`? The most common scenario is similar to this one:

                def result
                  # ...

                  error unless valid?
                  # instead of return error unless valid?

                  success
                end
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
