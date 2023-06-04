# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Failure
          class Middleware < MethodChainMiddleware
            intended_for :failure, entity: :service

            def next(*args, **kwargs, &block)
              return chain.next(*args, data: kwargs, &block) unless kwargs.has_key?(:data)

              Commands::AssertKwargsContainOnlyJSendKeys.call(kwargs: kwargs)

              chain.next(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
