# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module WrapsResultInDbTransaction
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
