# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      class RSpec
        class << self
          ##
          # @return [Boolean]
          #
          # @internal
          #   `Style/TernaryParentheses` is disable since `defined?` has too low priority without parentheses.
          #
          # rubocop:disable Style/TernaryParentheses
          def loaded?
            (defined? ::RSpec) ? true : false
          end
          # rubocop:enable Style/TernaryParentheses

          ##
          # @return [ConvenientService::Support::Version]
          #
          def version
            loaded? ? Support::Version.new(::RSpec::Core::Version::STRING) : Support::Version.null_version
          end
        end
      end
    end
  end
end
