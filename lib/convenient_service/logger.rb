# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ##
  # @example Usage.
  #
  #   ConvenientService::Logger.instance
  #   ConvenientService::Logger.instance.level = ::Logger::WARN
  #   ConvenientService::Logger.instance.warn { "log message" }
  #
  # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
  # @see https://newbedev.com/ruby-create-singleton-with-parameters
  #
  # @internal
  #   TODO: Custom matcher to track log messages.
  #   TODO: Fallback for logging methods. Just like with `#clean` in backtrace cleaner.
  #   TODO: Highlight vertical bars.
  #   TODO: Highlight tag brackets.
  #
  class Logger < ::Logger
    include ::Singleton

    class << self
      ##
      # @return [ConvenientService::Logger]
      #
      # @internal
      #   NOTE: `super` is `::Logger.new`.
      #   - https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html#method-c-new
      #
      #   IMPORTANT: Older versions of `::Logger` do NOT support `level` as a string.
      #   - https://github.com/ruby/logger/blob/v1.2.8.1/lib/logger.rb#L333
      #   - https://github.com/ruby/logger/blob/v1.2.8.1/lib/logger.rb#L740
      #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger.rb#L651
      #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger.rb#L397
      #
      #   TODO: Specs for `super(::STDOUT)`.
      #   TODO: Warning and fallback when `CONVENIENT_SERVICE_LOGGER_LEVEL` is NOT valid.
      #
      # rubocop:disable Style/GlobalStdStream
      def new
        super(::STDOUT).tap do |logger|
          logger.level =
            if ::ENV["CONVENIENT_SERVICE_DEBUG"] == "true"
              ::Logger::DEBUG
            elsif ::ENV["CONVENIENT_SERVICE_LOGGER_LEVEL"]
              ::ENV["CONVENIENT_SERVICE_LOGGER_LEVEL"]
            else
              ::Logger::INFO
            end

          logger.formatter = (::ENV["CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS"] == "true") ? colored_formatter : original_formatter
        end
      end
      # rubocop:enable Style/GlobalStdStream

      ##
      # @return [Logger::Formatter]
      #
      def original_formatter
        ::Logger::Formatter.new
      end

      ##
      # @return [Proc]
      #
      # @internal
      #   - https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html#method-i-add
      #
      #   IMPORTANT: Check `%w(DEBUG INFO WARN ERROR FATAL ANY)` for severity values.
      #   - https://github.com/ruby/logger/blob/v1.2.8.1/lib/logger.rb#L445
      #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger.rb#L736
      #
      def colored_formatter
        return original_formatter unless Dependencies.paint.loaded?

        proc do |severity, datetime, progname, message|
          log = original_formatter.call(severity, datetime, progname, message)

          case severity
          when "INFO" then ::Paint[log, :cyan, :bold]
          when "WARN" then ::Paint[log, :yellow, :bold]
          when "ERROR" then ::Paint[log, :red, :bold]
          when "FATAL" then ::Paint[log, :red, :underline]
          when "DEBUG" then ::Paint[log, :magenta, :bold]
          when "ANY" then log
          else log
          end
        end
      end
    end

    ##
    # @api public
    #
    # @internal
    #   IMPORTANT: Older versions of `Logger` do NOT support `level` as a string.
    #   - https://github.com/ruby/logger/blob/v1.2.8.1/lib/logger.rb#L333
    #   - https://github.com/ruby/logger/blob/v1.2.8.1/lib/logger.rb#L740
    #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger.rb#L651
    #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger.rb#L397
    #
    #   NOTE: Early return is NOT used, since it is NOT possible to return custom values from `writer` methods.
    #
    #   NOTE: `Warning.warn` is chosen over `Kernel.warn` in order to have a simple way to track delegation from RSpec.
    #   - https://ruby-doc.org/core-2.7.0/Warning.html#method-i-warn
    #
    # TODO: Tag/prefix for all Convenient Service logs.
    #
    def level=(severity)
      if Dependencies.support_logger_non_integer_levels?
        super
      elsif severity.instance_of?(::Integer)
        super
      else
        ::Warning.warn <<~MESSAGE
          `ConvenientService.logger.level` is reset from `#{severity}` to `Logger::INFO`.

          Stdlib `logger` with version `#{Dependencies.logger.version}` does NOT support non-integer levels.
        MESSAGE

        super(::Logger::INFO)
      end
    end
  end
end
