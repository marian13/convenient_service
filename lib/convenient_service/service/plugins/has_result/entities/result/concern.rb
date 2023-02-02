# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            ##
            # @internal
            #   This concern is needed for `CastResultClass` and `be_success`, `be_error`, `be_failure` matchers.
            #
            module Concern
            end
          end
        end
      end
    end
  end
end
