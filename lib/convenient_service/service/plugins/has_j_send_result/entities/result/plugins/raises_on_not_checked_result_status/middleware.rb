# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module RaisesOnNotCheckedResultStatus
                class Middleware < MethodChainMiddleware
                  intended_for [
                    :data,
                    :message,
                    :code
                  ], entity: :result

                  ##
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Exceptions::StatusIsNotChecked]
                  #
                  def next(...)
                    assert_has_checked_status!

                    chain.next(...)
                  end

                  private

                  ##
                  # @return [void]
                  # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Exceptions::StatusIsNotChecked]
                  #
                  def assert_has_checked_status!
                    return if entity.internals.cache.exist?(:has_checked_status)

                    raise Exceptions::StatusIsNotChecked.new(attribute: method)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
