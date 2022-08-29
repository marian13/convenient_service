# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        class Middleware < Core::MethodChainMiddleware
          ##
          # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
          #
          #   def next(...)
          #     # ...
          #
          #     chain.next(...)
          #   end
          #
          # rubocop:disable Style/ArgumentsForwarding
          def next(*args, **kwargs, &block)
            refute_has_result! || mark_as_has_result!

            chain.next(*args, **kwargs, &block)
          end
          # rubocop:enable Style/ArgumentsForwarding

          private

          ##
          # NOTE: `refute' is `!assert'.
          # https://docs.seattlerb.org/minitest
          #
          def refute_has_result!
            return unless entity.internals.cache.exist?(:has_result)

            raise Errors::DoubleResult.new(service: entity)
          end

          def mark_as_has_result!
            entity.internals.cache.write(:has_result, true)
          end
        end
      end
    end
  end
end
