# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Commands
          class FormatException < Support::Command
            ##
            # @!attribute [r] exception
            #   @return [StandardError]
            #
            attr_reader :exception

            ##
            # @!attribute [r] max_backtrace_size
            #   @return [Integer]
            #
            attr_reader :max_backtrace_size

            ##
            # @!attribute [r] args
            #   @return [StandardError]
            #
            attr_reader :args

            ##
            # @!attribute [r] kwargs
            #   @return [StandardError]
            #
            attr_reader :kwargs

            ##
            # @!attribute [r] block
            #   @return [StandardError]
            #
            attr_reader :block

            ##
            # @param exception [StandardError]
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @param max_backtrace_size [Integer]
            # @return [void]
            #
            def initialize(exception:, args:, kwargs:, block:, max_backtrace_size: Constants::DEFAULT_MAX_BACKTRACE_SIZE)
              @exception = exception
              @args = args
              @kwargs = kwargs
              @block = block
              @max_backtrace_size = max_backtrace_size
            end

            ##
            # @return [String]
            #
            # @note Exceptions formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @example Simple exception.
            #
            #   StandardError:
            #     exception message
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #
            # @example Exception with multiline message.
            #
            #   StandardError:
            #     exception message first line
            #     exception message second line
            #     exception message third line
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #
            # @example Exception with backtrace with more than 10 lines.
            #
            #   StandardError:
            #     exception message
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # ...
            #
            # @example Exception with cause.
            #
            #   StandardError:
            #     exception message
            #   # /gem/lib/convenient_service/factories/service/class.rb:43:in `rescue in result'
            #   # /gem/lib/convenient_service/factories/service/class.rb:40:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   ------------------
            #   --- Caused by: ---
            #   StandardError:
            #     cause message
            #   # /gem/lib/convenient_service/factories/service/class.rb:41:in `result'
            #
            # @internal
            #   TODO: Think about the following questions:
            #   - How to format args, kwargs and block?
            #   - Who should format them? The end-user or this plugin?
            #
            def call
              <<~MESSAGE.rstrip
                #{formatted_exception_class}
                #{formatted_exception_message}
                #{formatted_exception_backtrace}
                #{formatted_exception_cause}
              MESSAGE
            end

            private

            ##
            # @return [String]
            #
            def formatted_exception_class
              Commands::FormatClass.call(klass: exception.class)
            end

            ##
            # @return [String]
            #
            def formatted_exception_message
              Commands::FormatMessage.call(message: exception.message)
            end

            ##
            # Formats exception backtrace. When backtrace has more then `max_backtrace_size` lines, the extra lines are trimmed.
            # That is especially important for the monitoring system with the limited amount of memory, since it may too expensive to store the full backtrace all the time.
            #
            # @return [String]
            #
            # @internal
            #   TODO: Add an ability to set `max_backtrace_size` while configuring the middleware. For example:
            #
            #     class Service
            #       include ConvenientService::Standard::Config
            #
            #       middlewares :result, scope: :class do
            #         use ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware, max_backtrace_size: 1_000
            #       end
            #
            #       # ...
            #     end
            #
            def formatted_exception_backtrace
              Commands::FormatBacktrace.call(backtrace: exception.backtrace, max_size: max_backtrace_size)
            end

            ##
            # @return [String]
            #
            # @note `exception.cause` may be `$!`.
            # @see https://ruby-doc.org/core-2.7.0/Exception.html#method-i-cause
            #
            def formatted_exception_cause
              Commands::FormatCause.call(cause: exception.cause)
            end
          end
        end
      end
    end
  end
end
