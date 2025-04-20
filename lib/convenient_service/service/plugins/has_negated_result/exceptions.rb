# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasNegatedResult
        module Exceptions
          class NegatedResultIsNotOverridden < ::ConvenientService::Exception
            def initialize_with_kwargs(service:)
              message = <<~TEXT
                Negated result method (#negated_result) of `#{service.class}` is NOT overridden.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
