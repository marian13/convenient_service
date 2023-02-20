# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Commands
          class FormatCause < Support::Command
            ##
            # @!attribute [r] exception
            #   @return [StandardError, nil]
            #
            attr_reader :cause

            ##
            # @param cause [StandardError]
            # @return [void]
            #
            def initialize(cause:)
              @cause = cause
            end

            ##
            # @return [String]
            #
            # @note Cause formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @example Cause.
            #
            #   ------------------
            #   --- Caused by: ---
            #   StandardError:
            #     cause message
            #   # /gem/lib/convenient_service/factories/service/class.rb:41:in `result'
            #
            def call
              return "" unless cause

              <<~MESSAGE.chomp
                ------------------
                --- Caused by: ---
                #{cause.class}:
                  #{cause.message}
                #{formatted_cause_first_line}
              MESSAGE
            end

            private

            ##
            # @return [String, nil]
            #
            # @internal
            #   IMPORTANT: Sometimes `exception.backtrace` can be `nil`.
            #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
            #   - https://github.com/jruby/jruby/issues/4467
            #
            def cause_first_line
              return "" unless cause
              return "" unless cause.backtrace

              cause.backtrace.first
            end

            ##
            # @return [String, nil]
            #
            def formatted_cause_first_line
              return "" unless cause_first_line

              Commands::FormatLine.call(line: cause_first_line)
            end
          end
        end
      end
    end
  end
end
