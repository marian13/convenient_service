# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Logger.instance
#   ConvenientService::Logger.instance.level = ::Logger::WARN
#   ConvenientService::Logger.instance.warn { "log message" }
#
# Docs:
#
# - https://ruby-doc.org/stdlib-3.1.0/libdoc/logger/rdoc/Logger.html
# - https://newbedev.com/ruby-create-singleton-with-parameters
#
module ConvenientService
  ##
  # TODO: Custom matcher to track log messages.
  #
  class Logger < ::Logger
    include ::Singleton

    class << self
      private

      ##
      # @internal
      #   NOTE: `super` is `Logger.new`.
      #   - https://ruby-doc.org/stdlib-3.1.0/libdoc/logger/rdoc/Logger.html#method-c-new
      #
      # rubocop:disable Style/GlobalStdStream
      def new
        super(::STDOUT).tap do |logger|
          logger.level = ::ENV["CONVENIENT_SERVICE_LOGGER_LEVEL"] || "INFO"

          logger.formatter = colored_formatter if ::ENV["CONVENIENT_SERVICE_LOGGER_ENABLE_COLORS"] == "true"
        end
      end
      # rubocop:enable Style/GlobalStdStream

      def original_formatter
        ::Logger::Formatter.new
      end

      ##
      # https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html#method-i-add
      #
      def colored_formatter
        return original_formatter unless defined? ::Paint

        proc do |severity, datetime, progname, message|
          log = original_formatter.call(severity, datetime, progname, message)

          case severity.to_s.downcase
          when "info" then ::Paint[log, :cyan, :bold]
          when "warn" then ::Paint[log, :yellow, :bold]
          when "error" then ::Paint[log, :red, :bold]
          when "fatal" then ::Paint[log, :red, :underline]
          when "debug" then ::Paint[log, :magenta, :bold]
          else log
          end
        end
      end
    end
  end

  class << self
    def logger
      Logger.instance
    end
  end
end
