# frozen_string_literal: true

##
# @note Other gems are also trying to integrate with Rails Backtrace Cleaner.
# @see https://github.com/sidekiq/sidekiq/pull/5796
# @see https://github.com/sidekiq/sidekiq/issues/5589
# @see https://github.com/appsignal/appsignal-ruby/issues/380
#
module ConvenientService
  module Support
    ##
    # Rails v7.1.2 Backtrace Cleaner descendant.
    # Has Convenient Service specific silencer - `add_convenient_service_silencer`.
    # By default, it uses only `add_stdlib_silencer` and `add_convenient_service_silencer`.
    #
    # @see https://api.rubyonrails.org/classes/ActiveSupport/BacktraceCleaner.html
    # @see https://medium.com/one-medical-technology/filtering-ruby-backtraces-for-debugging-4df75133ab71
    # @see https://twitter.com/websebdev/status/1375831554518360065?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1375831554518360065%7Ctwgr%5E459595174e71c0f1aa3826c89f2ffca0c3da6ea3%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fwww.redditmedia.com%2Fmediaembed%2Fmegii9%2F%3Fresponsive%3Dtrueis_nightmode%3Dtrue
    # @see https://stackoverflow.com/questions/22727219/using-backtracecleaner-in-rails-console
    #
    class BacktraceCleaner < Dependencies::Extractions::ActiveSupportBacktraceCleaner::BacktraceCleaner
      ##
      # @return [void]
      #
      # @note `ConvenientService::Support::BacktraceCleaner` intentionally does NOT exclude external gems lines from backtrace.
      #
      # @see https://api.rubyonrails.org/classes/ActiveSupport/BacktraceCleaner.html
      # @see https://github.com/rails/rails/blob/v7.1.2/activesupport/lib/active_support/backtrace_cleaner.rb#L34
      #
      # @internal
      #   IMPORTANT: Convenient Service integrates with external gems.
      #   This means that external gems exceptions should NOT be considered as Convenient Service internal exceptions.
      #
      def initialize(...)
        super

        remove_filters!
        remove_silencers!

        ##
        # NOTE: Uses `::RbConfig` to resolve stdlib directory.
        # - https://idiosyncratic-ruby.com/42-ruby-config.html
        # - https://github.com/ruby/ruby/blob/master/tool/mkconfig.rb
        #
        add_stdlib_silencer

        ##
        # NOTE:
        #
        add_convenient_service_silencer
      end

      ##
      # @note `add_gem_filter` is made public to have a way to bring back Rails Backtrace Cleaner default behavior if necessary.
      #
      # @return [void]
      #
      # @see https://github.com/rails/rails/blob/v7.1.2/activesupport/lib/active_support/backtrace_cleaner.rb#L110
      #
      public :add_gem_filter

      ##
      # @note `add_gem_silencer` is made public to have a way to bring back Rails Backtrace Cleaner default behavior if necessary.
      #
      # @return [void]
      #
      # @see https://github.com/rails/rails/blob/v7.1.2/activesupport/lib/active_support/backtrace_cleaner.rb#L119
      #
      public :add_gem_silencer

      ##
      # @note `add_stdlib_silencer` is made public to allow the end-user to adjust clean in any way.
      #
      # @return [void]
      #
      # @see https://github.com/rails/rails/blob/v7.1.2/activesupport/lib/active_support/backtrace_cleaner.rb#L123
      #
      public :add_stdlib_silencer

      ##
      # Since Convenient Service is using middleware chains under the hood, exception backtraces may be huge.
      # As a consequence, it takes too much time during the debugging process to find the application line of code that causes the exception.
      # This silencer removes all Convenient Service lines from backtraces.
      #
      # @note To bring back Convenient Service lines to backtraces, use the `remove_silencers` or check the `CleansExceptionBacktrace` plugin.
      #
      # @return [void]
      #
      def add_convenient_service_silencer
        add_silencer do |line|
          next false if line.start_with?(::ConvenientService.examples_root.to_s)
          next false if line.start_with?(::ConvenientService.spec_root.to_s)

          line.start_with?(::ConvenientService.root.to_s)
        end
      end

      ##
      # Works exactly in the same way as the original `clean`, except it falls back to the original backtrace in case of any exceptions inside filters or silencers.
      # Also returns an empty array, when `backtrace` is `nil`.
      #
      # @return [Array<String>]
      #
      # @see https://api.rubyonrails.org/classes/ActiveSupport/BacktraceCleaner.html#method-i-clean
      #
      # @internal
      #   IMPORTANT: Sometimes `exception.backtrace` can be `nil`.
      #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
      #   - https://github.com/jruby/jruby/issues/4467
      #
      def clean(backtrace, *args)
        if backtrace.nil?
          ::ConvenientService.logger.warn { "[BacktraceCleaner] `nil` backtrace | Empty array is used as fallback" }

          return []
        end

        begin
          super
        rescue
          ::ConvenientService.logger.warn { "[BacktraceCleaner] Some filter or silencer is broken | Original backtrace is used as fallback" }

          backtrace
        end
      end
    end
  end
end
