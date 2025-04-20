# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module WrapsResultInDBTransaction
        class Middleware < MethodChainMiddleware
          intended_for :result, scope: :class, entity: :service

          def next(...)
            ::ActiveRecord::Base.transaction { chain.next(...) }
          end
        end
      end
    end
  end
end
