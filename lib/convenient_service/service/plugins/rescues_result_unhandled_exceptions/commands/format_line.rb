# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Commands
          class FormatLine < Support::Command
            ##
            # @!attribute [r] line
            #   @return [String]
            #
            attr_reader :line

            ##
            # @param line [String]
            # @return [void]
            #
            def initialize(line:)
              @line = line
            end

            ##
            # @return [String]
            #
            # @note Exceptions formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @example Line.
            #
            #   # /gem/lib/convenient_service/factories/services.rb:120:in `result'
            #
            def call
              "# #{line}"
            end
          end
        end
      end
    end
  end
end
