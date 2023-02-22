# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        class Middleware < Core::MethodChainMiddleware
          ##
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
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
            refute_has_result! || mark_as_has_result!

            chain.next(...)
          end

          private

          ##
          # @return [Boolean]
          # @raise [ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors::DoubleResult]
          #
          # @internal
          #   NOTE: `refute` is `!assert`.
          #   - https://docs.seattlerb.org/minitest
          #
          #   NOTE: This method contains a trailing exclamation mark in its name since it is mutable.
          #
          def refute_has_result!
            return unless entity.internals.cache.exist?(:has_result)

            raise Errors::DoubleResult.new(service: entity)
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
          def mark_as_has_result!
            entity.internals.cache.write(:has_result, true)
          end
        end
      end
    end
  end
end
