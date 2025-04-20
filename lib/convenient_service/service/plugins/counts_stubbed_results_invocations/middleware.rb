# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CountsStubbedResultsInvocations
        class Middleware < MethodChainMiddleware
          intended_for :result, scope: any_scope, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(...)
            result = chain.next(...)

            result.stubbed_result_invocations_counter.increment! if result.stubbed_result?

            result
          end
        end
      end
    end
  end
end
