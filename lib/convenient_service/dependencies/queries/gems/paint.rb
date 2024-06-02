# frozen_string_literal: true

module ConvenientService
  module Dependencies
    module Queries
      module Gems
        class Paint
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
              (defined? ::Paint) ? true : false
            end
            # rubocop:enable Style/TernaryParentheses

            ##
            # @api private
            #
            # @return [ConvenientService::Dependencies::Queries::Version]
            #
            # @internal
            #   - https://github.com/janlelis/paint/blob/v2.2.1/lib/paint/version.rb
            #
            def version
              loaded? ? Version.new(::Paint::VERSION) : Version.null_version
            end
          end
        end
      end
    end
  end
end
