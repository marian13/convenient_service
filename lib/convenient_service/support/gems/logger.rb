# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      class Logger
        class << self
          ##
          # @api private
          #
          # @return [Boolean]
          #
          # @internal
          #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
          #
          # rubocop:disable Style/TernaryParentheses
          def loaded?
            (defined? ::Logger) ? true : false
          end
          # rubocop:enable Style/TernaryParentheses

          ##
          # @api private
          #
          # @return [ConvenientService::Support::Version]
          #
          # @internal
          #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger/version.rb
          #
          def version
            loaded? ? Support::Version.new(::Logger::VERSION) : Support::Version.null_version
          end
        end
      end
    end
  end
end
