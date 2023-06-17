# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorArguments
        class Middleware < MethodChainMiddleware
          intended_for :initialize, entity: any_entity

          ##
          # @return [void]
          #
          def next(...)
            entity.internals.cache[:constructor_arguments] = Support::Arguments.new(...)

            chain.next(...)
          end
        end
      end
    end
  end
end
