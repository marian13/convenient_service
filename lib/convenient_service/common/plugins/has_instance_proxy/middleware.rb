# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        class Middleware < MethodChainMiddleware
          intended_for :new, scope: :class, entity: any_entity

          ##
          # @return [ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy]
          #
          def next(...)
            entity.instance_proxy_class.new(target: chain.next(...))
          end
        end
      end
    end
  end
end
