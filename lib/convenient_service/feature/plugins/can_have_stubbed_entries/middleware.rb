# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        class Middleware < MethodChainMiddleware
          intended_for :entry, entity: :feature

          ##
          # @internal
          #   TODO: Implement.
          #
          def next(...)
            chain.next(...)
          end
        end
      end
    end
  end
end
