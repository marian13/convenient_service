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
          class FormatMessage < Support::Command
            ##
            # @!attribute [r] message
            #   @return [String, nil]
            #
            attr_reader :message

            ##
            # @param message [String, nil]
            # @return [void]
            #
            def initialize(message:)
              @message = message
            end

            ##
            # @return [String]
            #
            # @note Message formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @note Underscores are used to highlight spaces in docs, they are NOT included in the resulting message, check `FormatException` for a full example.
            #
            # @example Message.
            #   __exception message
            #
            # @example Multiline message.
            #   __exception message first line
            #   __exception message second line
            #   __exception message third line
            #
            # @see ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatException
            #
            def call
              message.to_s.chomp.split("\n").map { |line| line.prepend(Constants::MESSAGE_LINE_PREFIX) }.join("\n")
            end
          end
        end
      end
    end
  end
end
