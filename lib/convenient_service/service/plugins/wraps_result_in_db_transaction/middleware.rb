# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module WrapsResultInDbTransaction
        class Middleware < Core::MethodChainMiddleware
          def next(...)
            ::ActiveRecord::Base.transaction { chain.next(...) }
          end
        end
      end
    end
  end
end
