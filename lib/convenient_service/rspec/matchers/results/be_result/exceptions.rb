# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeResult
          module Exceptions
            class InvalidStatus < ::ConvenientService::Exception
              ##
              # @api private
              #
              # @param status [Object] Can be any type.
              # @return [void]
              #
              def initialize_with_kwargs(status:)
                message = <<~TEXT
                  Status `#{status.inspect}` is NOT valid.

                  Valid statuses for `be_result` are `:success`, `:failure`, `:error`, `:not_success`, `:not_failure`, and `:not_error`.
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
