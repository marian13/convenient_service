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
          # rubocop:disable Style/ArgumentsForwarding
          def next(*args, **kwargs, &block)
            ::ActiveRecord::Base.transaction { chain.next(*args, **kwargs, &block) }
          end
          # rubocop:enable Style/ArgumentsForwarding
        end
      end
    end
  end
end
