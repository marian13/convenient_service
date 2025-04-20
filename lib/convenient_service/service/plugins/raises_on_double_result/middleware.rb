# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        class Middleware < MethodChainMiddleware
          intended_for :regular_result, entity: :service

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @internal
          #   TODO: Rewrite `RaisesOnDoubleResult` to make it thread-safe.
          #
          #   NOTE: Minimal reproducible example.
          #
          #     class Service
          #       include ConvenientService::Standard::Config
          #
          #       def result
          #         success
          #       end
          #     end
          #
          #     service = Service.new
          #
          #     10.times.reduce([]) { |threads| threads << Thread.new { service.result } }.join
          #
          def next(...)
            refute_has_j_send_result! || mark_as_has_j_send_result!

            chain.next(...)
          end

          private

          ##
          # @return [Boolean]
          # @raise [ConvenientService::Service::Plugins::RaisesOnDoubleResult::Exceptions::DoubleResult]
          #
          # @internal
          #   NOTE: `refute` is `!assert`.
          #   - https://docs.seattlerb.org/minitest
          #
          #   NOTE: This method contains a trailing exclamation mark in its name since it is mutable.
          #
          def refute_has_j_send_result!
            return unless entity.internals.cache.exist?(:has_j_send_result)

            ::ConvenientService.raise Exceptions::DoubleResult.new(service: entity)
          end

          ##
          # @return [Boolean]
          #
          # @internal
          #   NOTE: Name is inspired by `mark_as_read`.
          #   - https://github.com/ledermann/unread
          #
          #   NOTE: This method contains a trailing exclamation mark in its name since it is mutable.
          #
          def mark_as_has_j_send_result!
            entity.internals.cache.write(:has_j_send_result, true)
          end
        end
      end
    end
  end
end
