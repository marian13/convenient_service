# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          # @raise [ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult]
          #
          def next(...)
            entity.result_resolutions_counter.with_reset do |counter|
              chain.next(...)
                .tap { ::ConvenientService.raise Exceptions::DoubleResult.new(service: entity) if counter.value >= 2 }
            end
          end
        end
      end
    end
  end
end
