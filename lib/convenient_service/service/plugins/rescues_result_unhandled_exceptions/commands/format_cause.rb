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
                #{formatted_cause_class}
                #{formatted_cause_message}
                #{formatted_cause_first_line}
              MESSAGE
            end

            private

            ##
            # @return [String]
            #
            def formatted_cause_class
              Commands::FormatClass.call(klass: cause.class)
            end

            ##
            # @return [String]
            #
            def formatted_cause_message
              Commands::FormatMessage.call(message: cause.message)
            end

            ##
            # @return [String, nil]
            #
            # @internal
            #   IMPORTANT: Sometimes `exception.backtrace` can be `nil`.
            #   - https://blog.kalina.tech/2019/04/exception-without-backtrace-in-ruby.html
            #   - https://github.com/jruby/jruby/issues/4467
            #
            def formatted_cause_first_line
              cause_first_line = cause.backtrace.to_a.first

              cause_first_line ? Commands::FormatLine.call(line: cause_first_line) : ""
            end
          end
        end
      end
    end
  end
end
