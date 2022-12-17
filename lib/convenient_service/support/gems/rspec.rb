# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      ##
      # @api private
      #
      class RSpec
        class << self
          ##
          # @return [Boolean]
          #
          # @internal
          #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
          #
          # rubocop:disable Style/TernaryParentheses
          def loaded?
            (defined? ::RSpec) ? true : false
          end
          # rubocop:enable Style/TernaryParentheses

          ##
          # @return [ConvenientService::Support::Version]
          #
          # @internal
          #   https://github.com/rspec/rspec-core/blob/main/lib/rspec/core/version.rb
          #
          def version
            loaded? ? Support::Version.new(::RSpec::Core::Version::STRING) : Support::Version.null_version
          end
        end
      end
    end
  end
end
