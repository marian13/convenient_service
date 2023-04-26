# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        class Middleware < MethodChainMiddleware
          intended_for :result, scope: :class

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          # @internal
          #   NOTE: `rescue => exception` is the same as `rescue ::StandardError => exception`.
          #
          #   IMPORTANT: Never rescue `Exception` since its direct descendants are used internally by Ruby, rescue `StandardError` instead.
          #   - https://thoughtbot.com/blog/rescue-standarderror-not-exception
          #   - https://stackoverflow.com/questions/10048173/why-is-it-bad-style-to-rescue-exception-e-in-ruby
          #   - https://ruby-doc.org/core-2.7.0/Exception.html
          #
          def next(*args, **kwargs, &block)
            chain.next(*args, **kwargs, &block)
          rescue => exception
            failure_result_from(exception, *args, **kwargs, &block)
          end

          private

          ##
          # @param exception [StandardError]
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          def failure_result_from(exception, *args, **kwargs, &block)
            entity.failure(
              data: {exception: exception},
              message: format_exception(exception, *args, **kwargs, &block)
            )
          end

          ##
          # @param exception [StandardError]
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [String]
          #
          def format_exception(exception, *args, **kwargs, &block)
            Commands::FormatException.call(exception: exception, args: args, kwargs: kwargs, block: block, max_backtrace_size: max_backtrace_size)
          end

          ##
          # @return [Integer]
          #
          def max_backtrace_size
            arguments.kwargs.fetch(:max_backtrace_size) { Constants::DEFAULT_MAX_BACKTRACE_SIZE }
          end
        end
      end
    end
  end
end
