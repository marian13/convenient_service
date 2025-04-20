# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        class Middleware < MethodChainMiddleware
          intended_for :initialize, entity: :service

          ##
          # @return [void]
          #
          # @internal
          #   NOTE:
          #     Initializes service steps.
          #     That is done to commit(define) steps output methods before the first service instance created.
          #     This way `respond_to?` becomes consistent.
          #
          def next(...)
            entity.steps

            chain.next(...)
          end
        end
      end
    end
  end
end
