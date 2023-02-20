# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Commands
          class FormatBacktrace < Support::Command
            ##
            # @!attribute [r] backtrace
            #   @return [Array, nil]
            #
            attr_reader :backtrace

            ##
            # @!attribute [r] max_size
            #   @return [Integer]
            #
            attr_reader :max_size

            ##
            # @param backtrace [Array, nil]
            # @param max_size [Integer]
            # @return [void]
            #
            # @internal
            #   IMPORTANT: Sometimes `exception.backtrace` can be `nil`.
            #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
            #   - https://github.com/jruby/jruby/issues/4467
            #
            def initialize(backtrace:, max_size:)
              @backtrace = backtrace.to_a
              @max_size = max_size
            end

            ##
            # @return [String]
            #
            # @note Exceptions formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @example Backtrace with upto 10 lines.
            #
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_middlewares_caller.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_middlewares_caller.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #
            # @example Backtrace with more than 10 lines.
            #
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_middlewares_caller.rb:116:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_middlewares_caller.rb:116:in `block in result'
            #   # /gem/lib/convenient_service/dependencies/extractions/ruby_middleware/middleware/runner.rb:67:in `block (2 levels) in build_call_chain'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `block in next'
            #   # /gem/lib/convenient_service/support/cache.rb:110:in `fetch'
            #   # /gem/lib/convenient_service/common/plugins/caches_return_value/middleware.rb:17:in `next'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middleware.rb:73:in `call'
            #   # /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/chain.rb:35:in `next'
            #   # ...
            #
            def call
              message = backtrace.take(max_size).map { |line| Commands::FormatLine.call(line: line) }.join("\n")

              message << "\n# ..." if backtrace.size > max_size

              message
            end
          end
        end
      end
    end
  end
end
