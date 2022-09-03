# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module WrapsResultInDbTransaction
        class Middleware < Core::MethodChainMiddleware
          # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
          #
          #   def next(...)
          #     ::ActiveRecord::Base.transaction { chain.next(...) }
          #   end
          #
          def next(*args, **kwargs, &block)
            ::ActiveRecord::Base.transaction { chain.next(*args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
