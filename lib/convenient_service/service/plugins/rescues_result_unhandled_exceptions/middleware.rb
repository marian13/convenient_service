# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        class Middleware < MethodChainMiddleware
          intended_for [:regular_result, :steps_result], scope: :instance, entity: :service
          intended_for :result, scope: :class, entity: :service

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @note This middleware can be used for both instance and class `:result` methods.
          #
          # @example Usage for instance `:result`.
          #
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     middlewares :result do
          #       use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          #     end
          #   end
          #
          # @example Usage for class `:result`.
          #
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     middlewares :result, scope: :class do
          #       use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          #     end
          #   end
          #
          # @example Max backtrace size can be configured.
          #
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     middlewares :result do
          #       use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware.with(max_backtrace_size: 1_000)
          #     end
          #   end
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
            result_from_exception(exception, *args, **kwargs, &block)
          end

          private

          ##
          # @param exception [StandardError]
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def result_from_exception(exception, *args, **kwargs, &block)
            entity.public_send(
              status,
              data: {exception: exception},
              message: format_exception(exception, *args, **kwargs, &block)
            )
              .copy(overrides: {kwargs: {exception: exception}})
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
            middleware_arguments.kwargs.fetch(:max_backtrace_size) { Constants::DEFAULT_MAX_BACKTRACE_SIZE }
          end

          ##
          # @return [Integer]
          #
          def status
            middleware_arguments.kwargs.fetch(:status) { :error }
          end
        end
      end
    end
  end
end
