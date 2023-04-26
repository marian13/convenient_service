# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Success
          class Middleware < MethodChainMiddleware
            intended_for :success

            def next(**kwargs)
              Commands::RefuteKwargsContainDataAndExtraKeys.call(kwargs: kwargs)

              kwargs.has_key?(:data) ? chain.next(**kwargs) : chain.next(data: kwargs)
            end
          end
        end
      end
    end
  end
end
