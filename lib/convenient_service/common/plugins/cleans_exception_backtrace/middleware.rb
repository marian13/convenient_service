# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CleansExceptionBacktrace
        class Middleware < MethodChainMiddleware
          intended_for any_method, scope: any_scope, entity: any_entity

          ##
          # @return [Object] Can be any type.
          #
          # @raise [StandardError]
          #
          def next(...)
            chain.next(...)
          rescue => exception
            clean_backtrace!(exception)
            clean_backtrace!(exception.cause) if exception.cause

            raise
          end

          private

          ##
          # @return [Array<String>]
          #
          # @internal
          #   NOTE: Sometimes exceptions may have no backtrace, especially when they are created by developers manually, NOT by Ruby internals.
          #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
          #   - https://github.com/jruby/jruby/issues/4467
          #
          #   NOTE: Check the following tricky behaviour, it explains why an empty array is passed.
          #     `raise StandardError, "exception message", nil` ignores `nil` and still generates full backtrace.
          #     `raise StandardError, "exception message", []` generates no backtrace, but `exception.backtrace` returns `nil`.
          #
          def clean_backtrace!(exception)
            return unless exception.backtrace

            exception.backtrace.replace(backtrace_cleaner.clean(exception.backtrace))
          end

          ##
          # @return [ConvenientService::Support::BacktraceCleaner]
          #
          def backtrace_cleaner
            @backtrace_cleaner ||= middleware_arguments.kwargs.fetch(:backtrace_cleaner) { ::ConvenientService.backtrace_cleaner }
          end
        end
      end
    end
  end
end
